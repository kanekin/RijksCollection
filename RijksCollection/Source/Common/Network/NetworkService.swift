//
//  NetworkService.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation
import os.log

class NetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func load<T>(endpoint: Endpoint<T>) async throws -> T {
        do {
            Logger.network.debug("\(endpoint.request.curlString)")
            let (data, response) = try await session.data(for: endpoint.request)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            if response.statusCode == 401 {
                throw NetworkError.unauthenticated
            }

            if !(200..<300 ~= response.statusCode) {
                throw NetworkError.custom(
                    errorCode: response.statusCode,
                    errorDescription: HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                )
            }
            return try decoder.decode(endpoint.responseType, from: data)
            
        } catch {
            if let error = error as? NetworkError { throw error }
            
            let error = error as NSError
            if error.domain == NSURLErrorDomain,
                error.code == NSURLErrorNotConnectedToInternet {
                throw NetworkError.noInternet
            } else if let _ = error as? DecodingError {
                throw NetworkError.parsing(error: error)
            } else {
                throw NetworkError.unknown(error: error)
            }
        }
    }
}
