//
//  SceneDelegate.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/19/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        let initController = HomeViewController()
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            let navigationController = UINavigationController(rootViewController: initController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
    }

}

