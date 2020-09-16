//
//  MovieVideo.swift
//  MovieDB
//
//  Created by Ermac on 9/14/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation

struct MovieVideo: Codable, Hashable {
    enum Site: String, Codable {
        case youtube = "YouTube"
    }
    let key: String
    let name: String
    let site: Site
    var streamURL: URL?
    var thumbnailURL: URL?
}
