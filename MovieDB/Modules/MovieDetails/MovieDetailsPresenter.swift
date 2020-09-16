//
//  MovieDetailsPresenter.swift
//  MovieDB
//
//  Created by Ermac on 9/12/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import Foundation
import Combine
import XCDYouTubeKit

class MovieDetailsPresenter: TMDBNetworkInjected {
    
    private weak var view: MovieDetailsViewController?
    private let movieId: Int
    private var cancellables: [AnyCancellable] = []
    private var movie: Movie?
    private var videos = [MovieVideo]()
    private var youtubeVideos = [XCDYouTubeVideo]()
    
    init(movieId: Int, view: MovieDetailsViewController) {
        self.view = view
        self.movieId = movieId
    }
    
    func loadData() {
        cancellables.append(
            tmdbNetwork.getMovieDetails(movieId: movieId)
                .flatMap({ [weak self] movie -> Future<GetMovieVideosResponse, Error> in
                    guard let `self` = self else { return Future{$0(.failure(NSError()))} }
                    self.movie = movie
                    return self.tmdbNetwork.getMovieVideos(movieId: self.movieId)
                })
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print(error)
                    }
                }, receiveValue: { [weak self] response in
                    let videos = response.results
                    self?.videos.append(contentsOf: videos)
                    self?.loadYoutubeVideos()
                })
        )
    }
    
    private func loadYoutubeVideos() {
        let videoDownloadGroup = DispatchGroup()
        for video in videos {
            videoDownloadGroup.enter()
            XCDYouTubeClient.default().getVideoWithIdentifier(video.key) { [weak self] video, error in
                if let vi = video {
                    self?.youtubeVideos.append(vi)
                }
                videoDownloadGroup.leave()
            }
        }
        videoDownloadGroup.notify(queue: .main, work: DispatchWorkItem(block: { [weak self] in
            if let movie = self?.movie, let videos = self?.videos, let yv = self?.youtubeVideos {
                let videos: [MovieVideo] = zip(videos, yv).map { (movieInfo, youtubeVideo) in
                    var result = movieInfo
                    result.streamURL = youtubeVideo.streamURL
                    result.thumbnailURL = youtubeVideo.thumbnailURLs?.first
                    return result
                }
                self?.view?.update(with: movie, videos: videos)
            }
        }))
    }
}
