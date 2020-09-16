//
//  FeedItemCell.swift
//  MovieDB
//
//  Created by Ermac on 9/12/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import UIKit

class FeedItemCell: UICollectionViewCell, TMDBNetworkInjected {
    
    @IBOutlet private var itemImageView: UIImageView!
    @IBOutlet private var itemTitleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    
    private var favHandler: (() -> Void)? = nil
    
    func setup(with movie: Movie, addToFavorites: (() -> Void)? = nil) {
        itemTitleLabel.text = movie.title ?? movie.originalTitle ?? "Title not available"
        releaseDateLabel.text = movie.releaseDate ?? "Release date not available"
        let favImage = movie.isFavorite == true ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favoriteButton.setImage(favImage, for: .normal)
        if let voteAverage = movie.voteAverage, let voteCount = movie.voteCount {
            ratingLabel.text = "\(voteAverage) (\(voteCount) votes)"
        }
        if let poster = movie.posterPath,
            let url = URL(string: tmdbNetwork.environment.posterImageEndpoint + poster) {
            itemImageView.setImage(with: url)
        }
        favHandler = addToFavorites
    }
    
    func setup(with movie: StoredMovie, addToFavorites: (() -> Void)? = nil) {
        itemTitleLabel.text = movie.title ?? movie.originalTitle ?? "Title not available"
        releaseDateLabel.text = movie.releaseDate ?? "Release date not available"
        favoriteButton.isHidden = true
        if let voteAverage = movie.voteAverage, let voteCount = movie.voteCount {
            ratingLabel.text = "\(voteAverage) (\(voteCount) votes)"
        }
        if let poster = movie.posterPath,
            let url = URL(string: tmdbNetwork.environment.posterImageEndpoint + poster) {
            itemImageView.setImage(with: url)
        }
        favHandler = addToFavorites
    }
    
    @IBAction private func didClickAddToFavoritesButton(_ sender: UIButton) {
        favHandler?()
    }
}
