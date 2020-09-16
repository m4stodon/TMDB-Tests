//
//  TMDBRequestAdapter.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Alamofire

class TMDBRequestAdapter: BaseRequestAdapter {
    
    fileprivate let environment: TMDBNetworkEnvironment
    
    init(environment: TMDBNetworkEnvironment) {
        self.environment = environment
        super.init(baseURL: environment.endpoint)
    }
    
    override func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var components = self.components(for: urlRequest)
        
        // Insert API key into url query
        let apiKey = URLQueryItem(name: environment.apiKeyTitle, value: environment.apiKeyValue)
        if let _ = components?.queryItems {
            components?.queryItems?.append(apiKey)
        } else {
            components?.queryItems = [apiKey]
        }

        do {
            var request = urlRequest
            request.url = try components?.asURL()
            completion(.success(request))
        } catch {
            completion(.failure(error))
        }
    }
}
