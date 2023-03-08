//
//  OrderRequest.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/7/23.
//

import Alamofire
import SwiftyJSON

struct OrderRequest {
    
    let placeOrderRoute: String = "https://pharmacydelivery-production.up.railway.app/api/orders"
    
    var accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func placeOrder(order: [[String: Any]], address: String, completion: @escaping() -> Void) {
        
        let headers: HTTPHeaders = [
            .authorization(accessToken)
        ]
        
        let params: Parameters = [
            "orderDetails": order,
            "address": address
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            AF.request(placeOrderRoute, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).response { response in
                switch response.data {
                case .some(let data):
                    let json: JSON = JSON(data)
                    
                    if json["statusCode"].stringValue == "201" {
                        print(json)
                        completion()
                    }
                case .none: print("Nothing in response")
                }
            }
        }
    }
}
