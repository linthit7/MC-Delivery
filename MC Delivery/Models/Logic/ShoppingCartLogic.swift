//
//  ShoppingCartLogic.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/7/23.
//

import Foundation

struct ShoppingCartLogic {
    
    static func totalAmount(meds: [Med]) -> String {
        
        var totalAmount = 0
        
        if !meds.isEmpty {
            for med in meds {
                let totalCostOfSameMed = Int(med.price) * Int(med.quantity)
                totalAmount += Int(totalCostOfSameMed)
            }
        }
        return String(totalAmount)
    }
    
    static func medToOrder(meds: [Med], completion: @escaping ([[String: Any]]) -> Void) {
        
        var order = [[String: Any]]()
        
        for med in meds {
            let med_quan = Order.loadOrder(medicine: med).medicine_quantity
            order.append(med_quan!)
        }
        completion(order)
    }
    
    static func orderCleanUp(completion: @escaping() -> Void) {
        ShoppingCart.sharedInstance.removeAllItemFromPersistentStore {
            NotificationCenter.default.post(name: Alert.orderSuccessAndCleanUpDone.rawValue, object: nil)
        }
        completion()
    }
}

extension ShoppingCartLogic {
    
    enum Alert: NSNotification.Name {
        case orderSuccessAndCleanUpDone = "Order and Cleanup successful"
    }
}
