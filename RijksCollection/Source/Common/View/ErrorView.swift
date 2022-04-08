//
//  ErrorView.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import UIKit

class ErrorView: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [errorImageView, titleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 16.0
        return view
    }()
    
    private lazy var errorImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "xmark.octagon.fill")
        view.tintColor = .red
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 24.0, weight: .semibold)
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            errorImageView.heightAnchor.constraint(equalToConstant: 36.0),
            errorImageView.widthAnchor.constraint(equalToConstant: 36.0),
            leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topAnchor.constraint(equalTo: containerView.topAnchor),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        addSubview(stackView)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var errorMessage: String? {
        didSet {
            titleLabel.text = errorMessage
        }
    }
}
