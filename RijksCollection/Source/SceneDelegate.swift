//
//  SceneDelegate.swift
//  RijksCollection
//
//  Created by Tatsuya Kaneko on 05/04/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dependencies = Dependencies()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
//        let vc = PlaceholderViewController()
//        let vc = ArtDetailsViewController(presenter: dependencies.makeArtDetailsPresenter(objectNumber: "SK-C-5"))
        let vc = ArtCollectionViewController(presenter: dependencies.makeArtCollectionPresenter())
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

