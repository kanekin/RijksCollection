//
//  LoadingView.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [activityIndicatorView, titleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 16.0
        return view
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString("Loading...", comment: "loading.title")
        view.font = .systemFont(ofSize: 24.0, weight: .semibold)
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
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
}
