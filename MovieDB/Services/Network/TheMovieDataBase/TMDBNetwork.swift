//
//  TMDBNetwork.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON

struct TMDBNetworkEnvironment {
    let endpoint = "https://api.themoviedb.org/3/"
    let originalImageEndpoint = "https://image.tmdb.org/t/p/original/"
    let posterImageEndpoint = "https://image.tmdb.org/t/p/w500/"
    let apiKeyTitle = "api_key"
    let apiKeyValue = "58ed606381839241cb37d339084d2997"
}

final class TMDBNetwork {
    
    let environment: TMDBNetworkEnvironment
    fileprivate let session: Session
    private(set) var isReachable = CurrentValueSubject<Bool, Error>(true)
    private var reachabilityManager: NetworkReachabilityManager?
    
    init() {
        self.environment = TMDBNetworkEnvironment()
        let interceptor = Interceptor(adapter: TMDBRequestAdapter(environment: environment), retrier: TMDBNetworkRetrier())
        self.session = Session(interceptor: interceptor)
        
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening { [weak self] status in
            if case .reachable = status {
                self?.isReachable.send(true)
            } else {
                self?.isReachable.send(false)
            }
        }
    }
}

// MARK: - TMDB Requests
extension TMDBNetwork {
    func getTrendingItems(mediaType: MediaType, timeWindow: TimeWindow, page: Int) -> Future<GetPopularResponse, Error> {
        let request = GetTrendingItems(page: page, mediaType: mediaType, timeWindow: timeWindow)
        return session.request(request).tmdbResponse()
    }
    
    func getMovieDetails(movieId: Int) -> Future<Movie, Error> {
        let request = GetMovieDetails(movieId: movieId)
        return session.request(request).tmdbResponse()
    }
    
    func getMovieVideos(movieId: Int) -> Future<GetMovieVideosResponse, Error> {
        let request = GetMovieVideos(movieId: movieId)
        return session.request(request).tmdbResponse()
    }
}

// MARK: - DataRequest Future
fileprivate extension DataRequest {
    func tmdbResponse<T: Decodable, E: Error>() -> Future<T, E> {
        return Future { (completion: @escaping Future<T, E>.Promise) in
            self.responseData { (dataResponse: AFDataResponse<Data>) in
                guard let data = dataResponse.data else {
                    let error = AFError.responseValidationFailed(reason: .dataFileNil)
                    completion(.failure(error as! E))
                    return
                }
                
                #if DEBUG
                let json = try? JSON(data: data)
                print(json!)
                #endif
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let apiResponse = try decoder.decode(T.self, from: data)
                    completion(.success(apiResponse))
                } catch {
                    completion(.failure(error as! E))
                }
            }.validate()
        }
    }
}
