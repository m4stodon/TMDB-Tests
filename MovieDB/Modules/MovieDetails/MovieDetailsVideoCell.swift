//
//  MovieDetailsVideoCell.swift
//  MovieDB
//
//  Created by Ermac on 9/15/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import UIKit
import AVKit

class MovieDetailsVideoCell: UICollectionViewCell {
    @IBOutlet private var playerContainerView: UIView!
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var playButton: UIButton!
    
    private lazy var player: AVPlayer = {
        let player = AVPlayer()
        let playerLayer = AVPlayerLayer()
        playerContainerView.layer.addSublayer(playerLayer)
        playerLayer.player = player
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspect
        return player
    }()

    func setup(with movie: MovieVideo) {
        playButton.isHidden = false
        if let thumbnailURL = movie.thumbnailURL {
            thumbnailImageView.setImage(with: thumbnailURL)
        }
        if let streamURL = movie.streamURL {
            let playerItem = AVPlayerItem(url: streamURL)
            player.replaceCurrentItem(with: playerItem)
        }
    }
    
    @IBAction func didClickPlay(_ sender: Any) {
        thumbnailImageView.isHidden = true
        playButton.isHidden = true
        player.play()
    }
}
