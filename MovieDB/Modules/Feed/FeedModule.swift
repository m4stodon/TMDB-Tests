//
//  FeedModule.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import UIKit

struct FeedModuleInput {}

enum FeedModule {
    static func build(input: FeedModuleInput) -> FeedViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let view = storyboard.instantiateViewController(identifier: "FeedViewController") as! FeedViewController
        let presenter = FeedPresenter(view: view, router: view)
        view.presenter = presenter
        return view
    }
}
