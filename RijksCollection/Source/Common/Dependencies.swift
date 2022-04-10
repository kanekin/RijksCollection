//
//  Dependencies.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation
import UIKit

class Dependencies {
    
    private lazy var networkService: NetworkService = {
        return NetworkService(session: URLSession.shared, decoder: JSONDecoder())
    }()
    
    private lazy var artCollectionLoader: ArtCollectionLoading = {
        return ArtCollectionLoader(networkService: networkService)
    }()
    
    private lazy var artDetailsLoader: ArtDetailsLoading = {
        return ArtDetailsLoader(networkService: networkService)
    }()
   
    @MainActor
    func makeArtCollectionPresenter(navigationController: UINavigationController) -> ArtCollectionPresenter {
        return .init(
            loader: artCollectionLoader,
            router: ArtCollectionRouter(
                navigationController: navigationController,
                dependencies: self
            )
        )
    }
    
    func makeArtDetailsPresenter(objectNumber: String) -> ArtDetailsPresenter {
        return .init(
            objectNumber: objectNumber,
            loader: artDetailsLoader
        )
    }
}
