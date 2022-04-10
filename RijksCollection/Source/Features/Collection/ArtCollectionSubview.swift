//
//  ArtCollectionView.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import UIKit


fileprivate typealias DataSource = UICollectionViewDiffableDataSource<String, Model.Collection.ArtObject>
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<String, Model.Collection.ArtObject>

class ArtCollectionSubview: UIView {
    
    private var snapshot: Snapshot = .init()
    private var load: (() async -> ())?
    private var loadMore: (() -> ())?
    private var didSelectItem: ((Model.Collection.ArtObject) -> ())?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: ArtCollectionViewCell.reuseIdentifier)
        collectionView.register(ArtCollectionViewSectionHeader.self, forSupplementaryViewOfKind: ArtCollectionViewSectionHeader.reuseIdentifier, withReuseIdentifier: ArtCollectionViewSectionHeader.reuseIdentifier)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, artObject) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ArtCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? ArtCollectionViewCell
                cell?.artObject = artObject
                return cell
            }
        )
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            if let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ArtCollectionViewSectionHeader.reuseIdentifier,
                for: indexPath
            ) as? ArtCollectionViewSectionHeader {
                headerView.headerText = self?.snapshot.artists[indexPath.section]
                return headerView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        
        return dataSource
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let fullItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullItem.contentInsets = .init(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullItem,
            count: 2
        )
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: ArtCollectionViewSectionHeader.reuseIdentifier, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerItem]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            topAnchor.constraint(equalTo: collectionView.topAnchor),
            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ]
    }()
    
    convenience init(load: @escaping () async -> (), loadMore: @escaping () -> (), didSelectItem: @escaping (Model.Collection.ArtObject) -> ()) {
        self.init(frame: .zero)
        self.load = load
        self.loadMore = loadMore
        self.didSelectItem = didSelectItem
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateView(newArtObjects: [Model.Collection.ArtObject]) {
        updateSnapshot(newArtObjects: newArtObjects)
    }
    
    @objc private func refresh() {
        snapshot = Snapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
        Task {
            await load?()
            refreshControl.endRefreshing()
        }
    }
    
    private func updateSnapshot(newArtObjects: [Model.Collection.ArtObject]) {
        let newArtObjectsPerArtist = newArtObjects.dictionaryPerArtist
        
        // Keys of dictionary are not guranteed to be ordered
        for artist in Array(newArtObjectsPerArtist.keys).sorted() {
            // Add section if it doesn't exist yet
            if !snapshot.artists.contains(artist) {
                snapshot.appendSections([artist])
            }
            // Make sure that duplicates can not be added to the snapshot
            let existingItems = snapshot.artObjects(for: artist)
            let nonDuplicatedArtObjects = newArtObjectsPerArtist[artist]?.filter({
                !existingItems.contains($0)
            }) ?? []
            snapshot.appendItems(nonDuplicatedArtObjects.sorted(by: { $0.title > $1.title }), toSection: artist)
        }
       
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ArtCollectionSubview: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let artObject = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        didSelectItem?(artObject)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections - 1 && indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            loadMore?()
        }
    }
}

private extension Array where Element == Model.Collection.ArtObject {
    var dictionaryPerArtist: [String: [Model.Collection.ArtObject]] {
        return reduce([String:[Model.Collection.ArtObject]]()) { partialResult, artObject in
            var partialResult = partialResult
            let artist = artObject.principalOrFirstMaker ?? "Unknown"
            if let artObjects = partialResult[artist] {
                partialResult[artist] = artObjects + [artObject]
            } else {
                partialResult[artist] = [artObject]
            }
            return partialResult
        }
    }
}

extension Snapshot {
    var artists: [String] {
        sectionIdentifiers
    }
    
    func artObjects(for artist: String) -> [Model.Collection.ArtObject] {
        itemIdentifiers(inSection: artist)
    }
}
