//
//  PlaceholderViewController.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 08/04/2022.
//

import UIKit

class PlaceholderViewController: UIViewController {
    
//    private lazy var loadingView: LoadingView = {
//        let view = LoadingView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
   
    private lazy var targetView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.errorMessage = "Error!"
        return view
    }()
    
    private lazy var layoutConstraints: [NSLayoutConstraint] = {
        return [
            view.leadingAnchor.constraint(equalTo: targetView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: targetView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: targetView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: targetView.bottomAnchor)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(targetView)
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

