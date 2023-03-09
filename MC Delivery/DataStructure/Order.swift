//
//  Order.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/7/23.
//

import SwiftyJSON

struct Order {
    var medicine_quantity: [String: Any]!
    
    static func loadOrder(medicine: Med) -> Order {
        
        var order = Order()
        order.medicine_quantity = ["medicine": medicine.id!, "quantity": Int(medicine.quantity)]
        return order
    }
}

struct OrderHistoryResponse {
    
    var statusCode: Int!
    var payload: [OrderHistory]!
    var total: Int!
    var message: String!
    
    static func loadOrderHistoryResponse(json: JSON) -> OrderHistoryResponse {
        
        var orderHistoryResponse = OrderHistoryResponse()
        orderHistoryResponse.statusCode = json["statusCode"].intValue
        orderHistoryResponse.total = json["total"].intValue
        orderHistoryResponse.message = json["message"].stringValue
        return orderHistoryResponse
    }
    
}

struct OrderHistory {
    
    var _id: String!
    var id: String!
    var orderDetails: [OrderDetails]!
    var totalQuantity: Int!
    var totalPrice: Int!
    var user: String!
    var status: String!
    var address: String!
    var createdAt: String!
    var updatedAt: String!
    
    static func loadOrderHistory(json: JSON) -> OrderHistory {
        
        var orderHistory = OrderHistory()
        orderHistory._id = json["_id"].stringValue
        orderHistory.id = json["id"].stringValue
        orderHistory.orderDetails = OrderDetails.loadOrderDetailsArray(jsonArray: json["orderDetails"].arrayValue)
        orderHistory.totalQuantity = json["totalQuantity"].intValue
        orderHistory.totalPrice = json["totalPrice"].intValue
        orderHistory.user = json["user"].stringValue
        orderHistory.status = json["status"].stringValue
        orderHistory.address = json["address"].stringValue
        orderHistory.createdAt = json["createdAt"].stringValue
        orderHistory.updatedAt = json["updatedAt"].stringValue
        return orderHistory
    }
    
    static func loadOrderHistoryArray(jsonArray: [JSON]) -> [OrderHistory] {
        
        var orderHistoryArray: [OrderHistory] = []
        for json in jsonArray {
            let orderHistory = OrderHistory.loadOrderHistory(json: json)
            orderHistoryArray.append(orderHistory)
        }
        return orderHistoryArray
    }
}

struct OrderDetails {
    
    var medicine: Medicine!
    var quantity: Int!
    var _id: String!
    
    static func loadOrderDetails(json: JSON) -> OrderDetails {
        
        var orderDetails = OrderDetails()
        orderDetails.medicine = Medicine.loadMedicine(json: JSON(rawValue: json["medicine"].dictionaryValue)!)
        orderDetails.quantity = json["quantity"].intValue
        orderDetails._id = json["_id"].stringValue
        return orderDetails
    }
    
    static func loadOrderDetailsArray(jsonArray: [JSON]) -> [OrderDetails] {
        
        var orderDetailsArray = [OrderDetails]()
        for json in jsonArray {
            let orderDetails = OrderDetails.loadOrderDetails(json: json)
            orderDetailsArray.append(orderDetails)
        }
        return orderDetailsArray
    }
}
