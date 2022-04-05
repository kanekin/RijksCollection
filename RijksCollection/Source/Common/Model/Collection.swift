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
}

extension Model.Collection {
    struct ArtObject: Decodable {
        let id: String
        let objectNumber: String
        let title: String
        let hasImage: Bool
        let headerImage: RijksImage?
    }
}

struct RijksImage: Decodable {
    let guid: String
    let width: Int
    let height: Int
    let url: String
}
