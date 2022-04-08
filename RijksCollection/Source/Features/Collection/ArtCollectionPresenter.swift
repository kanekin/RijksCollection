//
//  ArtCollectionPresenter.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation
import os.log

actor ArtCollectionPresenter {
    
    private weak var view: ArtCollectionView?
    private let loader: ArtCollectionLoading
    private var lastPageLoaded = 1
    
    nonisolated init(loader: ArtCollectionLoading) {
        self.loader = loader
    }
    
    func attachView(_ view: ArtCollectionView) {
        print("view attached")
        self.view = view
    }
    
    func load(resetPageCount: Bool = false) async {
        do {
            let page = resetPageCount ? 1 : lastPageLoaded + 1
            let collection = try await loader.getCollection(page: page)
            await view?.updateView(collection.artObjects)
            lastPageLoaded = page
        } catch {
            Logger.network.error("Error on loading art collecion: \(error.localizedDescription)")

//                if let error = error as? NetworkError {
//                    switch error {
//                    case .invalidResponse, .custom, .unknown:
//                        // Unrecoverable errors
//                        Logger.network.error("Error on loading art collection: \(error.localizedDescription)")
//                        await view?.updateView(.failure("Failed to load art collection"))
//                    case .noInternet:
//                        await view?.updateView(.failure("No Internet. Try again later."))
//                    case .unauthenticated:
//                        // Not relevant in this project, but useful to show a relevant message for unauthenticated state. Possibly prompt login screen.
//                        await view?.updateView(.failure("Failed to load art collection"))
//                    case .parsing(error: let error):
//                        // Unrecoverable, but this type of error should be logged remote logging system with a dedicated error message.
//                        Logger.network.error("Pasing error: \(error.localizedDescription)")
//                        await view?.updateView(.failure("Failed to load art collection"))
//                    }
//                } else {
//                    Logger.network.error("Error on loading art colleciont: \(error.localizedDescription)")
//                }
        }
        
    }
    
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
