//
//  FeedViewController.swift
//  MovieDB
//
//  Created by Ermac on 9/11/20.
//  Copyright © 2020 Ermac. All rights reserved.
//

import UIKit
import SVPullToRefresh

class FeedViewController: UIViewController {
    
    var presenter: FeedPresenter?
    
    @IBOutlet private var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private lazy var collectionViewDataSource: DataSource = {
        return DataSource(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedItemCell", for: indexPath) as? FeedItemCell
            cell?.setup(with: movie, addToFavorites: {
                self?.presenter?.addToFavorites(at: indexPath.row)
            })
            return cell
        })
    }()
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    private lazy var snapshot = Snapshot()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalWidth(1.05))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: layoutItem, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.addInfiniteScrolling { [unowned self] in
            self.presenter?.loadData()
        }
        presenter?.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func applySnapshot(movies: [Movie]) {
        snapshot.numberOfSections == 0 ? snapshot.appendSections([.main]) : snapshot.reloadSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
        collectionView.infiniteScrollingView.stopAnimating()
    }
    
    func reload(movie: Movie) {
        snapshot.reloadItems([movie])
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: -
extension FeedViewController: UICollectionViewDelegate {
    // MARK: UICollectionView Sections
    enum Section {
        case main
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectItem(at: indexPath.item)
    }
}
