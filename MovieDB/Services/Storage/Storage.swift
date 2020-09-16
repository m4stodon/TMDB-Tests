//
//  Storage.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import CoreStore
import CoreData

class Storage {
    
    let dataStack: DataStack
    
    init() {
        // Creates NSPersistentStoreCoordinator
        // + root NSManagedObjectContext for disk saves
        // + shared NSManagedObjectContext designed as a read-only model interface
        // CoreStoreSchema uses NSManagedObject descriptions from source as CoreStoreObject
        let dataStack = DataStack(
            CoreStoreSchema(
                modelVersion: "V1",
                entities: [
                    Entity<StoredMovie>("StoredMovie"),
                    Entity<StoredGenre>("StoredGenre")
                ]
            )
        )
        
        CoreStoreDefaults.dataStack = dataStack
        self.dataStack = dataStack
        
        // Create SQLLite file
        do {
            try dataStack.addStorageAndWait(
                SQLiteStore(
                    fileName: "MovieDB.sqlite",
                    localStorageOptions: .recreateStoreOnModelMismatch
                )
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}


