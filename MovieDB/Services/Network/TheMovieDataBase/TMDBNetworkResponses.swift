//
//  TMDBNetworkResponse.swift
//  MovieDB
//
//  Created by Ermac on 9/12/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation

struct GetPopularResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
}

struct GetMovieVideosResponse: Codable {
    let id: Int
    let results: [MovieVideo]
}
