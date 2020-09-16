//
//  FavoritesPresenter.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import CoreStore

class FavoritesPresenter: StorageInjected {
    
    private weak var view: FavoritesViewController?
    private weak var router: FavoritesRouter?
    private var publisher: ListPublisher<StoredMovie>?
    
    init(view: FavoritesViewController, router: FavoritesRouter) {
        self.view = view
        self.router = router
        self.publisher = storage.dataStack.publishList(
            From<StoredMovie>(),
            OrderBy<StoredMovie>(.descending("title"))
        )
    }
    
    deinit {
        publisher?.removeObserver(self)
    }
    
    func loadData() {
        publisher?.addObserver(self) { [weak self] listPublisher in
            let snaphot = listPublisher.snapshot
            self?.view?.update(with: snaphot)
        }
        if let snapshot = publisher?.snapshot {
            view?.update(with: snapshot)
        }
    }
    
    func removeFromFavorites(id: Int) {
        storage.dataStack.perform(asynchronous: { transaction -> Void in
            try transaction.deleteAll(
                From<StoredMovie>(),
                Where<StoredMovie>("id", isEqualTo: id)
            )
        }, completion: { _ in })
    }
}
