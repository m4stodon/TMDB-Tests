//
//  Genre.swift
//  MovieDB
//
//  Created by Ermac on 9/12/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import CoreStore
import CoreData

struct Genre: Codable {
    var id: Int = 0
    var name: String = ""
}

class StoredGenre: CoreStoreObject {
    @Field.Stored("id") var id: Int = 0
    @Field.Stored("name") var name: String = ""
    @Field.Relationship("movie") var movie: StoredMovie?
}
