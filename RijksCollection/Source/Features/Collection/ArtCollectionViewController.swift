//
//  ArtCollectionViewController.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import UIKit

@MainActor
protocol ArtCollectionView: AnyObject {
    func update(artObjects: [Model.Collection.ArtObject])
}

@MainActor
class ArtCollectionViewController: UIViewController, ArtCollectionView {
    
    private let presenter: ArtCollectionPresenter
    
    init(presenter: ArtCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
    }

    func update(artObjects: [Model.Collection.ArtObject]) {
        print(artObjects)
    }
}

