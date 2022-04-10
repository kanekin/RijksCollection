//
//  ArtCollectionViewSectionHeader.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 10/04/2022.
//

import UIKit

class ArtCollectionViewSectionHeader: UICollectionReusableView {
    private var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .label
        view.font = .systemFont(ofSize: 20.0, weight: .semibold)
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ]
    }()
    
    var headerText: String? {
        didSet {
            label.text = headerText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        directionalLayoutMargins = .init(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        addSubview(label)
        NSLayoutConstraint.activate(layoutConstraints)
//        backgroundColor = .secondarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
