//
//  AppRouter.swift
//  MovieDB
//
//  Created by Ermac on 9/16/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import UIKit

final class AppRouter {
    
    enum InitialRoute {
        case feed
        case favorites
    }
    
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func open(initial route: InitialRoute) {
        
        let feedVC = FeedModule.build(input: FeedModuleInput())
        let feed = UINavigationController(rootViewController: feedVC)
        feedVC.tabBarItem = UITabBarItem(title: "Feed",
                                         image: UIImage(systemName: "globe"),
                                         selectedImage: nil)
        
        let favoritesVC = FavoritesModule.build(input: FavoritesModuleInput())
        let favorites = UINavigationController(rootViewController: favoritesVC)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites",
                                              image: UIImage(systemName: "star.fill"),
                                              selectedImage: nil)
        
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([feed, favorites], animated: false)
        // preload all vc
        tabBarVC.viewControllers?.forEach {
            _ = ($0 as? UINavigationController)?.viewControllers.first?.view
        }
        
        switch route {
        case .feed: tabBarVC.selectedIndex = 0
        case .favorites: tabBarVC.selectedIndex = 1
        }
        
        window?.rootViewController = tabBarVC
    }
}
