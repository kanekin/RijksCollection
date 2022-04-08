//
//  Endpoints.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation

extension Endpoint {
    static func getCollection(page: Int) -> Endpoint<Model.Collection> {
        guard let url: URL = .init(
            fromRijksApiPath: "/api/en/collection",
            additionalQueryItems: [
                URLQueryItem(name: "ps", value: "20"),
                URLQueryItem(name: "p", value: "\(page)"),
                URLQueryItem(name: "s", value: "artist")
            ]) else {
            preconditionFailure("Could not instantiate URL object with: \(#function)")
        }
        
        return .init(url: url, httpMethod: .get)
    }
    
    static func getDetails(objectNumber: String) -> Endpoint<Model.Details> {
        guard let url: URL = .init(fromRijksApiPath: "/api/en/collection/\(objectNumber)") else {
            preconditionFailure("Could not instantiate URL object with: \(#function)")
        }
        
        return .init(url: url, httpMethod: .get)
    }
}

extension URL {
    init?(fromRijksApiPath path: String, additionalQueryItems: [URLQueryItem] = []) {
        guard var urlComponents = URLComponents(string: ApiConstants.baseUrl) else { return nil }
        urlComponents.path = path
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: String(ApiConstants.apiKey)),
        ] + additionalQueryItems
        guard let url = urlComponents.url else { return nil }
        self = url
    }
}
