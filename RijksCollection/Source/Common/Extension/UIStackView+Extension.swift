//
//  UIStackView+Extension.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
    
    func replaceArrangedSubviews(_ views: [UIView]) {
        removeSubviews()
        addArrangedSubviews(views)
    }
}


