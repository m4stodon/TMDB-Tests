//
//  FavoritesRouter.swift
//  MovieDB
//
//  Created by Ermac on 9/16/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import UIKit

protocol FavoritesRouter: class {
    func open(route: FavoritesViewController.Route)
}

extension FavoritesViewController: FavoritesRouter {
    enum Route {
        case itemDetails(id: Int)
    }
    
    func open(route: Route) {
        switch route {
        case .itemDetails(let movieId):
            performSegue(withIdentifier: "showMovieDetails", sender: movieId)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showMovieDetails",
            let destination = segue.destination as? MovieDetailsViewController,
            let movieId = sender as? Int {
            let input = MovieDetailsModuleInput(movieId: movieId)
            MovieDetailsModule.build(view: destination, input: input)
        }
    }
}

