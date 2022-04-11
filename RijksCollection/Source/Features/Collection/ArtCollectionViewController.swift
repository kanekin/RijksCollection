//
//  ArtCollectionViewController.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import UIKit


protocol ArtCollectionView: AnyObject {
    @MainActor
    func updateView(_ newArtObjects: [Model.Collection.ArtObject])
    @MainActor
    func displayErrorMessage(_ message: String?)
}

@MainActor
class ArtCollectionViewController: UIViewController, ArtCollectionView {
    
    private let presenter: ArtCollectionPresenter
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [errorMessageView, artCollectionView, activityIndicatorContainerView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.setCustomSpacing(16.0, after: artCollectionView)
        return view
    }()
    
    private lazy var errorMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var artCollectionView: ArtCollectionSubview = {
        let view = ArtCollectionSubview(
            load: { [weak self] in
                await self?.presenter.load(resetPageCount: true)
            },
            loadMore: {
                Task { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicatorContainerView.isHidden = false
                    self.activityIndicatorView.startAnimating()
                    await self.presenter.load()
                    self.activityIndicatorContainerView.isHidden = true
                    self.activityIndicatorView.stopAnimating()
                }
            },
            didSelectItem: { [weak self] artObject in
                guard let objectNumber = artObject.objectNumber else { return }
                self?.presenter.displayDetailsPage(objectNumber: objectNumber)
            }
        )
        return view
    }()
    
    private lazy var activityIndicatorContainerView: UIView = {
        let view = UIView()
        view.directionalLayoutMargins = .init(top: 16.0, leading: 0.0, bottom: 16.0, trailing: 0.0)
        view.isHidden = true
        return view
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            errorMessageLabel.topAnchor.constraint(equalTo: errorMessageView.layoutMarginsGuide.topAnchor),
            errorMessageLabel.bottomAnchor.constraint(equalTo: errorMessageView.layoutMarginsGuide.bottomAnchor),
            errorMessageLabel.leadingAnchor.constraint(equalTo: errorMessageView.layoutMarginsGuide.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: errorMessageView.layoutMarginsGuide.trailingAnchor),
            activityIndicatorContainerView.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            activityIndicatorContainerView.layoutMarginsGuide.topAnchor.constraint(equalTo: activityIndicatorView.topAnchor),
            activityIndicatorContainerView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor),
        ]
    }()
    
    init(presenter: ArtCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        activityIndicatorContainerView.addSubview(activityIndicatorView)
        errorMessageView.addSubview(errorMessageLabel)
        NSLayoutConstraint.activate(layoutConstraints)
        self.navigationItem.title = NSLocalizedString("Collection", comment: "navigation.title")
        presenter.attachView(self)
        Task {
            await presenter.load(resetPageCount: true)
        }
    }

    func updateView(_ newArtObjects: [Model.Collection.ArtObject]) {
        errorMessageView.isHidden = true
        artCollectionView.updateView(newArtObjects: newArtObjects)
    }
    
    func displayErrorMessage(_ message: String?) {
        errorMessageView.isHidden = message == nil
        errorMessageLabel.text = message
    }
}

