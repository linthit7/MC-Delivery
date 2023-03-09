//
//  OrderHistoryLogic.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/9/23.
//

import Foundation

struct OrderHistoryLogic {
    
    func getAllMedicineName(orderHistory: OrderHistory) -> [String] {
        
        var allName: [String] = []
        
        for medicine in orderHistory.orderDetails {
            let name = medicine.medicine.name
            allName.append(name!)
        }
        return allName
    }
}
