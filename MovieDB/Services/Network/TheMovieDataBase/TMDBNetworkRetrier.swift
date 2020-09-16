//
//  TMDBNetworkRetrier.swift
//  MovieDB
//
//  Created by Ermac on 9/15/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Alamofire

class TMDBNetworkRetrier: RequestRetrier {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let err = error as NSError
        if err.code == 13 { // No network error
            completion(.retryWithDelay(5))
        } else {
            completion(.doNotRetry)
        }
    }
}
