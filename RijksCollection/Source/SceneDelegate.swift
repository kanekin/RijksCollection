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
        let navigationController = UINavigationController()
        let vc = ArtCollectionViewController(presenter: dependencies.makeArtCollectionPresenter(navigationController: navigationController))
        navigationController.viewControllers = [vc]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
