//
//  ArtCollectionViewCell.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import Foundation
import UIKit
import os.log

class ArtCollectionViewCell: UICollectionViewCell {
    
    private var imageLoadingTask: Task<Void, Error>?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.tintColor = .white
        return view
    }()
    
    private lazy var textStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [UIView(), titleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16.0, weight: .semibold)
        view.numberOfLines = 0
        view.textColor = .white
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            contentView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: imageView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: textStackView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: textStackView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: textStackView.bottomAnchor),
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(textStackView)
        contentView.backgroundColor = .systemGray
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var artObject: Model.Collection.ArtObject? {
        didSet {
            titleLabel.text = artObject?.title
            
            imageLoadingTask = Task {
                let image = await artObject?.webImage?.imageURL(width: Int(frame.width))?.fetchImage()
                await MainActor.run {
                    imageView.image = image
                }
                imageLoadingTask = nil
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let task = imageLoadingTask else { return }
        Logger.ui.debug("Cancelling image downloading task")
        task.cancel()
        imageView.image = nil
    }
}
