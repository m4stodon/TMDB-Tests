//
//  FeedPresenter.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Combine

class FeedPresenter: TMDBNetworkInjected, StorageInjected {
    
    private var cancellables: [AnyCancellable] = []
    weak var view: FeedViewController?
    weak var router: FeedRouter?
    
    private var movies = [Movie]()
    private var currentPage = 1
    
    init(view: FeedViewController, router: FeedRouter) {
        self.view = view
        self.router = router
    }
    
    func loadData() {
        let dataStack = storage.dataStack
        cancellables.append(tmdbNetwork.getTrendingItems(mediaType: .all, timeWindow: .week, page: currentPage)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] response in
                
                // Sync isFavorite for feed list movies with storage
                let movies: [Movie] = response.results.map { movie in
                    var mov = movie
                    if mov.isStored(using: dataStack) {
                        // Mark local copy as favorite
                        mov.isFavorite = true
                    }
                    return mov
                }
                
                self?.movies.append(contentsOf: movies)
                self?.currentPage += 1
                self?.view?.applySnapshot(movies: movies)
            })
        )
    }
    
    func addToFavorites(at index: Int) {
        if movies[index].isFavorite == true {
            // update local copy
            movies[index].isFavorite = false
            // remove from store
            movies[index].deleteFromStore(using: storage.dataStack)
        } else {
            // update local copy
            movies[index].isFavorite = true
            // add to store
            movies[index].saveOrUpdateStore(using: storage.dataStack)
        }
        // update view
        view?.reload(movie: movies[index])
    }
    
    func didSelectItem(at index: Int) {
        guard let itemId = movies[index].id else { return }
        router?.open(route: .itemDetails(id: itemId))
    }
}
