//
//  CreateOrJoinRoomRequest.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/23/23.
//

import SwiftyJSON
import Alamofire

struct CreateOrJoinRoomRequest {
    
    var accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func creatOrJoinRoom(completion: @escaping (MCRoom) -> Void) {
        
        let creatOrJoinRoomRoute: String = "https://pharmacydelivery-production.up.railway.app/api/rooms"
        
        let headers: HTTPHeaders = [
            .authorization(accessToken)
        ]

        DispatchQueue.global(qos: .userInitiated).async {
            
            AF.request(creatOrJoinRoomRoute, method: .post, encoding: JSONEncoding.default, headers: headers).response { response in
                switch response.data {
                case .some(let data):
                    let json: JSON = JSON(data)
                    if json["statusCode"].stringValue == "200" {
                        print(json)
                        let mcRoom = MCRoom.loadRoom(json: JSON(rawValue: json["payload"].dictionaryValue)!)
                        completion(mcRoom)
                    }
                case .none: print("No data in CreateOrJoinRoomRequest")
                }
            }
        }
    }
}
