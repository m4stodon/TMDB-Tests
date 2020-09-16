//
//  FavoritesModule.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import UIKit

struct FavoritesModuleInput {}

enum FavoritesModule {
    static func build(input: FavoritesModuleInput) -> FavoritesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let view = storyboard.instantiateViewController(identifier: "FavoritesViewController") as! FavoritesViewController
        let presenter = FavoritesPresenter(view: view, router: view)
        view.presenter = presenter
        return view
    }
}
