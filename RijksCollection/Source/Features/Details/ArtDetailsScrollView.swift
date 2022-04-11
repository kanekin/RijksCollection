//
//  ArtDetailsScrollView.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import UIKit

class ArtDetailsScrollView: UIView {
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var outerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            artImageView,
            textStackView
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private lazy var artImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var textStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            titleLabel,
            makersLabel,
            titlesStackView,
            descriptionTitleLabel,
            descriptionLabel
        ])
        view.axis = .vertical
        view.spacing = 8.0
        view.directionalLayoutMargins = .init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 36.0, weight: .bold)
        return view
    }()

    private lazy var makersLabel: UILabel = {
       let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 24.0, weight: .semibold)
        return view
    }()
    
    private lazy var titlesStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8.0
        return view
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 24.0, weight: .semibold)
        view.text = NSLocalizedString("Description", comment: "details.description.title")
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            topAnchor.constraint(equalTo: scrollView.topAnchor),
            bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            leadingAnchor.constraint(equalTo: outerStackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: outerStackView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: outerStackView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: outerStackView.bottomAnchor),
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(outerStackView)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(artObject: Model.Details.ArtObject?) {
        titleLabel.text = artObject?.title
        titlesStackView.replaceArrangedSubviews(artObject?.titles.map {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = $0
            return label
        } ?? [])
        
        makersLabel.text = artObject?.principalMakers.map { $0.name }.joined(separator: ", ")
        descriptionTitleLabel.isHidden = (artObject?.description == nil)
        descriptionLabel.text = artObject?.description
        
        Task {
            let image = await artObject?.webImage?.imageURL(width: Int(frame.width))?.fetchImage()
            await MainActor.run {
                artImageView.image = image
            }
        }
    }
}
