//
//  Endpoints.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation

struct Endpoints {
    static func getCollection(page: Int) -> Endpoint<Model.Collection> {
        guard let url: URL = .init(fromRijksApiPath: "/api/en/collection?ps=20&s=artist&p=\(page)") else {
            preconditionFailure("Could not instantiate URL object with: \(#function)")
        }
        
        return .init(url: url, httpMethod: .get)
    }
    
    static func getDetails(objectNumber: String) -> Endpoint<Model.Collection> {
        guard let url: URL = .init(fromRijksApiPath: "/api/en/collection/\(objectNumber)") else {
            preconditionFailure("Could not instantiate URL object with: \(#function)")
        }
        
        return .init(url: url, httpMethod: .get)
    }
}

extension URL {
    init?(fromRijksApiPath path: String) {
        guard var urlComponents = URLComponents(string: ApiConstants.baseUrl) else { return nil }
        urlComponents.path = path
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: String(ApiConstants.apiKey)),
        ]
        guard let url = urlComponents.url else { return nil }
        self = url
    }
}
