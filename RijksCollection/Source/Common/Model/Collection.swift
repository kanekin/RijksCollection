//
//  Collection.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import Foundation

struct Model {
    struct Collection: Decodable {
        let count: Int
        let artObjects: [ArtObject]
    }
    
    struct Details: Decodable {
        let artObject: ArtObject
    }
}

extension Model.Collection {
    struct ArtObject: Decodable {
        let id: String?
        let objectNumber: String?
        let title: String
        let hasImage: Bool?
        let webImage: RijksImage?
        let principalOrFirstMaker: String?
    }
}

extension Model.Collection.ArtObject: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(objectNumber)
    }
    
    static func == (lhs: Model.Collection.ArtObject, rhs: Model.Collection.ArtObject) -> Bool {
        return lhs.objectNumber == rhs.objectNumber
    }
}

extension Model.Details {
    struct ArtObject: Decodable {
        let id: String
        let title: String
        let titles: [String]
        let description: String?
        let webImage: RijksImage?
        let principalMakers: [Maker]
    }
}

extension Model.Details.ArtObject {
    struct Maker: Decodable {
        let name: String
        let occupation: [String]
        let dateOfBirth: String?
        let dateOfDeath: String?
    }
}

struct RijksImage: Decodable {
    let guid: String?
    let width: Int?
    let height: Int?
    let url: String?
}
