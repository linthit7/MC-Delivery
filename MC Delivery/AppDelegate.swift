//
//  AppDelegate.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/19/23.
//

import UIKit
import AVFAudio

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var loginState: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if CredentialsStore.getCredentials()?.accessToken != nil {
        
            AppDelegate.loginState = true
            SocketHandler.sharedInstance.establishConnection(token: CredentialsStore.getCredentials()?.accessToken ?? "")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}


}

