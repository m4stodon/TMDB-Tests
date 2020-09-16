//
//  BaseNetworkRequest.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Alamofire

typealias Params = [String: Any?]
typealias HTTPMethod = Alamofire.HTTPMethod

protocol BaseNetworkRequest: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var params: Params? { get }
}

extension BaseNetworkRequest {
    func asURLRequest() throws -> URLRequest {
        
        let escapedPath = URLEncoding.default.escape(path)
        let url = URL(string: escapedPath)
        
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        var parameters: Parameters = [:]
        self.params?.forEach { key, value in
            if let value = value {
                parameters[key] = value
            }
        }
        
        switch method {
        case .get, .post, .put:
            return try URLEncoding.default.encode(request, with: parameters)
        default:
            return try JSONEncoding.default.encode(request, with: parameters)
        }
    }
}
