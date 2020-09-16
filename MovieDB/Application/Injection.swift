//
//  Injection.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation

protocol StorageInjected {}
extension StorageInjected {
    var storage: Storage {
        return AppSession.current.storage
    }
}

protocol TMDBNetworkInjected {}
extension TMDBNetworkInjected {
    var tmdbNetwork: TMDBNetwork {
        return AppSession.current.tmdbNetwork
    }
}
