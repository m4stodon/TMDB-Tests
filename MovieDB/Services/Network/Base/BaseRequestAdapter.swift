//
//  BaseRequestAdapter.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Alamofire

class BaseRequestAdapter: RequestAdapter {
    
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func components(for urlRequest: URLRequest) -> URLComponents? {
        let path = urlRequest.url?.absoluteString ?? ""
        return URLComponents(string: baseURL.appending(path))
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let components = self.components(for: urlRequest)
        var request = urlRequest
        do {
            request.url = try components?.asURL()
            completion(.success(request))
        } catch {
            completion(.failure(error))
        }
    }
}

