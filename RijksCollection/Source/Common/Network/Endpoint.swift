//
//  Endpoint.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation

enum HTTPMethod {
    case get
    case post(Encodable)
    case put(Encodable)
    case patch(Encodable)
    case delete
}

extension HTTPMethod {
    var string: String {
        switch self {
        case .get: return "get"
        case .post: return "post"
        case .put: return "put"
        case .patch: return "patch"
        case .delete: return "delete"
        }
    }
}

struct Endpoint<T: Decodable> {
    let request: URLRequest
    let responseType: T.Type
}

extension Endpoint where T: Decodable {
    init(url: URL, httpMethod: HTTPMethod) {
        var urlRequest: URLRequest {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod.string
            
            return urlRequest
        }
                
        self.request = urlRequest
        self.responseType = T.self
    }
}

extension Encodable {
    func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
