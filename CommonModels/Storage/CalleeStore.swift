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
    
    static func storeOrderHistory(orderHistory: OrderHistory) {
        
        do {
            let standardUserDefaults = UserDefaults.standard
            let data = try JSONEncoder().encode(orderHistory)
            standardUserDefaults.set(data, forKey: "OrderHistory")
        } catch {
            print("Error storing orderhistory to userdefaults")
        }
    }
    
    static func getOrderHistory() -> OrderHistory? {
        
        let standardUserDefaults = UserDefaults.standard
        
        if let credentials = standardUserDefaults.data(forKey: "OrderHistory") {
            do {
                let data = try
                JSONDecoder().decode(OrderHistory.self, from: credentials)
                return data
            } catch {
                print("Error getting credentials from userdefaults")
            }
        }
        return nil
    }
}
