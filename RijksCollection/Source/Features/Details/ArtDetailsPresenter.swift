//
//  ArtDetailsPresenter.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import Foundation
import os.log

class ArtDetailsPresenter {
    
    enum State {
        case loading
        case success(Model.Details.ArtObject)
        case failure(String)
    }
    
    private let objectNumber: String
    private let loader: ArtDetailsLoading
    private weak var view: ArtDetailsView?
    private var artObject: Model.Details.ArtObject?
    
    init(objectNumber: String, loader: ArtDetailsLoading) {
        self.objectNumber = objectNumber
        self.loader = loader
    }
    
    func attachView(_ view: ArtDetailsView) {
        self.view = view
    }
    
    func load() {
        Task {
            await view?.updateView(.loading)
            
            do {
                let details = try await loader.getDetails(objectNumber: objectNumber)
                self.artObject = details.artObject
                await view?.updateView(.success(details.artObject))
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .invalidResponse, .custom, .unknown:
                        // Unrecoverable errors
                        Logger.network.error("Error on loading art details: \(error.localizedDescription)")
                        await view?.updateView(.failure("Failed to load art details"))
                    case .noInternet:
                        await view?.updateView(.failure("No Internet. Try again later."))
                    case .unauthenticated:
                        // Not relevant in this project, but useful to show a relevant message for unauthenticated state. Possibly prompt login screen.
                        await view?.updateView(.failure("Failed to load art details"))
                    case .parsing(let error):
                        // Unrecoverable, but this type of error should be logged remote logging system with a dedicated error message.
                        #if DEBUG
                        print(error)
                        #endif
                        await view?.updateView(.failure("Failed to load art details"))
                    }
                } else {
                    Logger.network.error("Error on loading art details: \(error.localizedDescription)")
                }
            }
        }
    }
}


protocol ArtDetailsLoading {
    func getDetails(objectNumber: String) async throws -> Model.Details
}

class ArtDetailsLoader: ArtDetailsLoading {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getDetails(objectNumber: String) async throws -> Model.Details {
        return try await networkService.load(endpoint: .getDetails(objectNumber: objectNumber))
    }
}
