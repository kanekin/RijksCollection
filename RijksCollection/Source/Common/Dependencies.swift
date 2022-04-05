//
//  Dependencies.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation

class Dependencies {
    
    private lazy var networkService: NetworkService = {
        return NetworkService(session: URLSession.shared, decoder: JSONDecoder())
    }()
    
    private lazy var artCollectionLoader: ArtCollectionLoading = {
        return ArtCollectionLoader(networkService: networkService)
    }()
   
    func makeArtCollectionPresenter() -> ArtCollectionPresenter {
        return .init(
            loader: artCollectionLoader
        )
    }
}
