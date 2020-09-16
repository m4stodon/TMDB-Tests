//
//  MovieDetailsModule.swift
//  MovieDB
//
//  Created by Ermac on 9/12/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation

struct MovieDetailsModuleInput {
    let movieId: Int
}

enum MovieDetailsModule {
    static func build(view: MovieDetailsViewController, input: MovieDetailsModuleInput) {
        let presenter = MovieDetailsPresenter(movieId: input.movieId, view: view)
        view.presenter = presenter
    }
}
