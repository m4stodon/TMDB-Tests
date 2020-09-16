//
//  Movie.swift
//  MovieDB
//
//  Created by Ermac on 9/12/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import CoreStore
import CoreData

class Movie: Codable {
    var id: Int? // 337401
    var imdbId: String? // tt4566758
    var title: String? // Mulan
    var releaseDate: String? // 2020-09-04
    var homepage: String? // https://movies.disney.com/mulan-2020
    var posterPath: String? // /aKx1ARwG55zZ0GpRvU2WrGrCG9o.jpg
    var backdropPath: String? // /xl5oCFLVMo4d4Pgxvrf8Jmc2IlA.jpg
    var budget: Double? //200000000
    var adult: Bool?
    var originalLanguage: String? //en
    var originalTitle: String? // Mulan
    var overview: String?
    var popularity: Double? //2340.511
    var revenue: Double? // 0
    var runtime: Double? // 115
    var video: Bool? // false
    var voteAverage: Double? // 7.8
    var voteCount: Int? // 1236
    var genres: [Genre]?
    var isFavorite: Bool? = false
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

// Explicit mapping for CoreStoreObjects
extension Movie {
    func isStored(using dataStack: DataStack) -> Bool {
        let result = try? dataStack.perform { transaction -> StoredMovie? in
            return try? transaction.fetchOne(
                From<StoredMovie>(),
                Where<StoredMovie>("id", isEqualTo: self.id)
            )
        }
        return result != nil
    }
    
    func deleteFromStore(using dataStack: DataStack) {
        dataStack.perform(asynchronous: { transaction in
            try? transaction.deleteAll(
                From<StoredMovie>(),
                Where<StoredMovie>("id", isEqualTo: self.id)
            )
        }, completion: { _ in })
    }
    
    func saveOrUpdateStore(using dataStack: DataStack) {
        dataStack.perform(asynchronous: { transaction in
            let storedMovie = try? transaction.fetchOne(
                From<StoredMovie>(),
                Where<StoredMovie>("id", isEqualTo: self.id)
            )
            if let movie = storedMovie {
                // update existing movie
                movie.imdbId = self.imdbId
                movie.title = self.title
                movie.releaseDate = self.releaseDate
                movie.homepage = self.homepage
                movie.posterPath = self.posterPath
                movie.backdropPath = self.backdropPath
                movie.budget = self.budget
                movie.adult = self.adult
                movie.originalLanguage = self.originalLanguage
                movie.originalTitle = self.originalTitle
                movie.overview = self.overview
                movie.popularity = self.popularity
                movie.revenue = self.revenue
                movie.runtime = self.runtime
                movie.video = self.video
                movie.voteAverage = self.voteAverage
                movie.voteCount = self.voteCount
            } else {
                // create new movie
                self.createAndStore(using: dataStack)
            }
        }, completion: { _ in })
    }
    
    fileprivate func createAndStore(using dataStack: DataStack) {
        dataStack.perform(asynchronous: { transaction in
            let movie = transaction.create(Into<StoredMovie>())
            movie.id = self.id
            movie.imdbId = self.imdbId
            movie.title = self.title
            movie.releaseDate = self.releaseDate
            movie.homepage = self.homepage
            movie.posterPath = self.posterPath
            movie.backdropPath = self.backdropPath
            movie.budget = self.budget
            movie.adult = self.adult
            movie.originalLanguage = self.originalLanguage
            movie.originalTitle = self.originalTitle
            movie.overview = self.overview
            movie.popularity = self.popularity
            movie.revenue = self.revenue
            movie.runtime = self.runtime
            movie.video = self.video
            movie.voteAverage = self.voteAverage
            movie.voteCount = self.voteCount
            // movie.genres: [Genre]
            movie.isFavorite = self.isFavorite
        }, completion: { _ in })
    }
}

class StoredMovie: CoreStoreObject {
    @Field.Stored("id") var id: Int? // 337401
    @Field.Stored("imdb_id") var imdbId: String? // tt4566758
    @Field.Stored("title") var title: String? // Mulan
    @Field.Stored("release_date") var releaseDate: String? // 2020-09-04
    @Field.Stored("homepage") var homepage: String? // https://movies.disney.com/mulan-2020
    @Field.Stored("poster_path") var posterPath: String? // /aKx1ARwG55zZ0GpRvU2WrGrCG9o.jpg
    @Field.Stored("backdrop_path") var backdropPath: String? // /xl5oCFLVMo4d4Pgxvrf8Jmc2IlA.jpg
    @Field.Stored("budget") var budget: Double? //200000000
    @Field.Stored("adult") var adult: Bool?
    @Field.Stored("original_language") var originalLanguage: String? //en
    @Field.Stored("original_title") var originalTitle: String? // Mulan
    @Field.Stored("overview") var overview: String?
    @Field.Stored("popularity") var popularity: Double? //2340.511
    @Field.Stored("revenue") var revenue: Double? // 0
    @Field.Stored("runtime") var runtime: Double? // 115
    @Field.Stored("video") var video: Bool? // false
    @Field.Stored("vote_average") var voteAverage: Double? // 7.8
    @Field.Stored("vote_count") var voteCount: Int? // 1236
    @Field.Relationship("genres", inverse: \.$movie) var genres: [StoredGenre]
    @Field.Stored("isFavorite") var isFavorite: Bool? = false
}
