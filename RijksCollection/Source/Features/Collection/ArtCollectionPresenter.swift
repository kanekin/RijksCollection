//
//  ArtCollectionPresenter.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation

class ArtCollectionPresenter {
    
    private weak var view: ArtCollectionView?
    private let loader: ArtCollectionLoading
    private var lastPageLoaded = 0
    private var artObjects: [Model.Collection.ArtObject] = [] {
        didSet {
            Task {
                await view?.update(artObjects: artObjects)
            }
        }
    }
    
    init(loader: ArtCollectionLoading) {
        self.loader = loader
    }
    
    func attachView(_ view: ArtCollectionView) {
        self.view = view
    }
    
    func load() async {
        do {
            let collection = try await loader.getCollection(page: 0)
            
            artObjects = collection.artObjects
        } catch {
            // Do error handling
        }
    }
    
//    func loadMore() -> Model.Collection {
//
//    }
}

protocol ArtCollectionLoading {
    func getCollection(page: Int) async throws -> Model.Collection
}

class ArtCollectionLoader: ArtCollectionLoading {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCollection(page: Int) async throws -> Model.Collection {
        return try await networkService.load(endpoint: .getCollection(page: page))
    }
}
