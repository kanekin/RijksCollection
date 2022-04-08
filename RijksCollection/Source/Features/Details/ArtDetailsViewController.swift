//
//  ArtDetailsViewController.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 07/04/2022.
//

import UIKit

@MainActor
protocol ArtDetailsView: AnyObject {
    func updateView(_ state: ArtDetailsPresenter.State)
}

@MainActor
class ArtDetailsViewController: UIViewController, ArtDetailsView {
    private var presenter: ArtDetailsPresenter
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var artDetailsScrollView: ArtDetailsScrollView = {
        let view = ArtDetailsScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            view.leadingAnchor.constraint(equalTo: errorView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            view.topAnchor.constraint(equalTo: errorView.topAnchor),
            view.bottomAnchor.constraint(equalTo: errorView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor),
            view.topAnchor.constraint(equalTo: loadingView.topAnchor),
            view.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: artDetailsScrollView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: artDetailsScrollView.trailingAnchor),
            view.topAnchor.constraint(equalTo: artDetailsScrollView.topAnchor),
            view.bottomAnchor.constraint(equalTo: artDetailsScrollView.bottomAnchor),
        ]
    }()
    
    init(presenter: ArtDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(errorView)
        view.addSubview(loadingView)
        view.addSubview(artDetailsScrollView)
        NSLayoutConstraint.activate(layoutConstraints)
        presenter.attachView(self)
        presenter.load()
    }
    
    func updateView(_ state: ArtDetailsPresenter.State) {
        switch state {
        case .loading:
            errorView.setIsHidden(true, animated: true)
            loadingView.setIsHidden(false, animated: true)
            artDetailsScrollView.setIsHidden(true, animated: true)
        case .success(let artObject):
            artDetailsScrollView.updateView(artObject: artObject)
            errorView.setIsHidden(true, animated: true)
            loadingView.setIsHidden(true, animated: true)
            artDetailsScrollView.setIsHidden(false, animated: true)
        case .failure(let errorMessage):
            errorView.errorMessage = errorMessage
            errorView.setIsHidden(false, animated: true)
            loadingView.setIsHidden(true, animated: true)
            artDetailsScrollView.setIsHidden(false, animated: true)
        }
    }
}

extension RijksImage {
    func imageURL(width: Int) -> URL? {
        var urlString = url
        if urlString.contains("=") {
            urlString.append("-")
        } else {
            urlString.append("=")
        }
        urlString.append("w\(width)")
        
        guard let urlWithSize = URL(string: urlString) else {
            return nil
        }
        return urlWithSize
    }
}


