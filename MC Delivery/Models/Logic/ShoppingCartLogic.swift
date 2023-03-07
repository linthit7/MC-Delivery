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
        
        if meds.isEmpty == false {
            for med in meds {
                totalAmount += Int(med.price)
            }
        }
        return String(totalAmount)
    }
}
