//
//  TMDBNetworkRequests.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Trending

enum MediaType: String {
    case all
    case movie
    case tv
}

enum TimeWindow: String {
    case day
    case week
}

struct GetTrendingItems: BaseNetworkRequest {
    let method = HTTPMethod.get
    let page: Int
    let mediaType: MediaType
    let timeWindow: TimeWindow
    var path: String {
        return "trending/\(mediaType.rawValue)/\(timeWindow.rawValue)"
    }
    var params: Params? {
        return ["page": "\(page)"]
    }
}

struct GetMovieDetails: BaseNetworkRequest {
    let method = HTTPMethod.get
    let movieId: Int
    var path: String {
        return "movie/\(movieId)"
    }
    var params: Params? = nil
}

struct GetMovieVideos: BaseNetworkRequest {
    let method = HTTPMethod.get
    let movieId: Int
    var path: String {
        return "movie/\(movieId)/videos"
    }
    var params: Params? = nil
}
