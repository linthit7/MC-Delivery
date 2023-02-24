//
//  CredentialsStore.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/24/23.
//

import Foundation

struct CredentialsStore {
    
    static func storeCredentials(payload: Payload) {
        
        do {
            let standardUserDefaults = UserDefaults.standard
            let data = try JSONEncoder().encode(payload)
            standardUserDefaults.set(data, forKey: "Credentials")
            AppDelegate.loginState = true
            NotificationCenter.default.post(name: NSNotification.Name("Login Successful"), object: nil)
            
            print("Successfully stored", payload)
        } catch {
            print("Error storing credentials")
        }
    }
    
}
