//
//  ArtCollectionViewController.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import UIKit

@MainActor
protocol ArtCollectionView: AnyObject {
    func updateView(_ newArtObjects: [Model.Collection.ArtObject])
}

@MainActor
class ArtCollectionViewController: UIViewController, ArtCollectionView {
    
    private let presenter: ArtCollectionPresenter
    
    private lazy var artCollectionView: ArtCollectionSubview = {
        let view = ArtCollectionSubview(
            loadMore: {
                Task { [weak self] in
                    await self?.presenter.load()
                }
            },
            didSelectItem: { [weak self] artObject in
                guard let objectNumber = artObject.objectNumber else { return }
                self?.presenter.displayDetailsPage(objectNumber: objectNumber)
            }
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            view.leadingAnchor.constraint(equalTo: artCollectionView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: artCollectionView.trailingAnchor),
            view.topAnchor.constraint(equalTo: artCollectionView.topAnchor),
            view.bottomAnchor.constraint(equalTo: artCollectionView.bottomAnchor),
        ]
    }()
    
    init(presenter: ArtCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(artCollectionView)
        NSLayoutConstraint.activate(layoutConstraints)
        self.navigationItem.title = NSLocalizedString("Collection", comment: "navigation.title")
        Task {
            await presenter.attachView(self)
            await presenter.load(resetPageCount: true)
        }

    }

    func updateView(_ newArtObjects: [Model.Collection.ArtObject]) {
        print("updatedView")
        artCollectionView.updateView(newArtObjects: newArtObjects)
    }
}

