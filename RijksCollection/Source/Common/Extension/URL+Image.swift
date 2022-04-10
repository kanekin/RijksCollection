//
//  URL+Image.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 10/04/2022.
//

import UIKit

extension URL {
    func fetchImage() async -> UIImage? {
        return try? await ImageLoader.shared.image(from: self)
    }
}
