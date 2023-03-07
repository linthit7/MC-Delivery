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
}
