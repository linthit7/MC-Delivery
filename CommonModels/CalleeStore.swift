//
//  CalleeStore.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/28/23.
//

import Foundation

struct CalleeStore {
    
    static func storeCallee(callee: ExistingUser) {
        
        do {
            let standardUserDefaults = UserDefaults.standard
            let data = try JSONEncoder().encode(callee)
            standardUserDefaults.set(data, forKey: "Callee")
        } catch {
            print("Error storing callee to userdefaults")
        }
    }
    
    static func getCallee() -> ExistingUser? {
        
        let standardUserDefaults = UserDefaults.standard
        
        if let credentials = standardUserDefaults.data(forKey: "Callee") {
            do {
                let data = try
                JSONDecoder().decode(ExistingUser.self, from: credentials)
                return data
            } catch {
                print("Error getting credentials from userdefaults")
            }
        }
        return nil
    }
}
