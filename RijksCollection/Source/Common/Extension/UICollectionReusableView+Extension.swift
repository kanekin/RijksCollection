//
//  UICollectionReusableView+Extension.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 10/04/2022.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
