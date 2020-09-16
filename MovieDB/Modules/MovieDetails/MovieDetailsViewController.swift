//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Ermac on 9/12/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var presenter: MovieDetailsPresenter?
    
    @IBOutlet private var videosCollectionView: UICollectionView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    enum Section {
        case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieVideo>
    private lazy var collectionViewDataSource: DataSource = {
        return DataSource(collectionView: videosCollectionView, cellProvider: { (collectionView, indexPath, video) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailsVideoCell",
                                                          for: indexPath) as? MovieDetailsVideoCell
            cell?.setup(with: video)
            return cell
        })
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [unowned self] item, _, _ in
            if let page = item.last?.indexPath.row {
                self.pageControl.currentPage = page
                self.pageControl.updateCurrentPageDisplay()
            }
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videosCollectionView.collectionViewLayout = collectionViewLayout
        presenter?.loadData()
    }
    
    func update(with movie: Movie, videos: [MovieVideo]) {
        if !videos.isEmpty {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieVideo>()
            snapshot.appendSections([.main])
            snapshot.appendItems(videos, toSection: .main)
            collectionViewDataSource.apply(snapshot, animatingDifferences: true)
            pageControl.numberOfPages = snapshot.numberOfItems
            videosCollectionView.isHidden = false
            pageControl.isHidden = false
        } else {
            videosCollectionView.isHidden = true
            pageControl.isHidden = true
        }
        
        titleLabel.text = movie.title ?? movie.originalTitle ?? "Title unavailable"
        descriptionLabel.text = movie.overview
        activityIndicator.stopAnimating()
    }
}
