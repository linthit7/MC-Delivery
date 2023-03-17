//
//  OrderRequest.swift
//  MC Delivery Carrier
//
//  Created by Lin Thit Khant on 3/17/23.
//

import Alamofire
import SwiftyJSON

struct OrderRequest {
    
    let baseOrderRoute = "https://pharmacydelivery-production.up.railway.app"
    
    func getOngoingOrderRouteCarrier(accessToken: String, completion: @escaping([OrderHistory]) -> Void) {
        
        let route = "\(baseOrderRoute)/api/deliveryPersons/orders"
        
        let headers: HTTPHeaders = [
            .authorization(accessToken)
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            AF.request(route, method: .get, encoding: JSONEncoding.default, headers: headers).response { response in
                switch response.data {
                case .some(let data):
                    let json: JSON = JSON(data)
                    if json["statusCode"].stringValue == "200" {
                        let payload = OrderHistory.loadOrderHistoryArray(jsonArray: json["payload"].arrayValue)
                        completion(payload)
                    }
                case .none: print("Nothing in response")
                }
            }
        }
    }
}
