//
//  NetworkError.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation

enum NetworkError {
    case invalidResponse
    case noInternet
    case unauthenticated
    case parsing(error: DecodingError)
    case custom(errorCode: Int?, errorDescription: String?)
    case unknown(error: Error?)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .noInternet: return "No Internet"
            case .invalidResponse: return "Invalid response"
            case .unauthenticated: return "Unauthenticated User"
            case .parsing(let error): return "Parsing error: \(error.localizedDescription))"
            case .custom(_, let errorDescription): return errorDescription
            case .unknown(let error): return "Unknown error: \(error?.localizedDescription ?? "")"
        }
    }

    var errorCode: Int? {
        switch self {
            case .noInternet: return nil
            case .invalidResponse: return nil
            case .unauthenticated: return nil
            case .parsing: return nil
            case .custom(let errorCode, _): return errorCode
            case .unknown: return nil
        }
    }
}

