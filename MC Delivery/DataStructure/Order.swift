//
//  Order.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/7/23.
//

import Foundation

struct Order {
    var medicine_quantity: [String: Any]!
    
    static func loadOrder(medicine: Med) -> Order {
        
        var order = Order()
        order.medicine_quantity = ["medicine": medicine.id!, "quantity": Int(medicine.quantity)]
        return order
    }
}


