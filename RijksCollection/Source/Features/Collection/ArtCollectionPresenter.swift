//
//  ArtCollectionPresenter.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation
import os.log
import UIKit

class ArtCollectionPresenter {
    
    private weak var view: ArtCollectionView?
    private let loader: ArtCollectionLoading
    private let router: ArtCollectionRouting
    private let pageCounter = PageCounter()
    var lastPageLoaded: Int {
        get async {
            await pageCounter.count
        }
    }
    
    init(loader: ArtCollectionLoading, router: ArtCollectionRouting) {
        self.loader = loader
        self.router = router
    }
    
    func attachView(_ view: ArtCollectionView) {
        self.view = view
    }
    
    func load(resetPageCount: Bool = false) async {
        if resetPageCount {
            await pageCounter.reset()
        } else {
            await pageCounter.increment()
        }
        
        do {
            let collection = try await loader.getCollection(page: pageCounter.count)
            await view?.updateView(collection.artObjects)
        } catch {
            if let error = error as? NetworkError {
                switch error {
                case .invalidResponse, .custom, .unknown:
                    // Unrecoverable errors
                    Logger.network.error("Error on loading art collection: \(error.localizedDescription)")
                    await view?.displayErrorMessage("Failed to load art collection")
                case .noInternet:
                    await view?.displayErrorMessage("No Internet. Try again later.")
                case .unauthenticated:
                    // Not relevant in this project, but useful to show a relevant message for unauthenticated state. Possibly prompt login screen.
                    await view?.displayErrorMessage("Failed to load art collection")
                case .parsing(error: let error):
                    // Unrecoverable, but this type of error should be logged remote logging system with a dedicated error message.
                    Logger.network.error("Pasing error: \(error.localizedDescription)")
                    await view?.displayErrorMessage("Failed to load art collection")
                }
            } else {
                Logger.network.error("Error on loading art colleciont: \(error.localizedDescription)")
            }
        }
        
    }
    
    @MainActor
    func displayDetailsPage(objectNumber: String) {
        router.displayDetailsPage(objectNumber: objectNumber)
    }
}

actor PageCounter {
    private static let initialValue = 1
    var count: Int = PageCounter.initialValue
    
    func increment() {
        count += 1
    }
    
    func reset() {
        count = PageCounter.initialValue
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

protocol ArtCollectionRouting {
    @MainActor
    func displayDetailsPage(objectNumber: String)
}


class ArtCollectionRouter: ArtCollectionRouting {
    
    private let dependencies: Dependencies?
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    @MainActor
    func displayDetailsPage(objectNumber: String) {
        guard let presenter = dependencies?.makeArtDetailsPresenter(objectNumber: objectNumber) else {
            return
        }
        let vc = ArtDetailsViewController(presenter: presenter)
        navigationController?.pushViewController(vc, animated: true)
    }
}
