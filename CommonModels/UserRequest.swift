//
//  UserRequest.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import SwiftyJSON
import Alamofire

struct UserRequest {
    
    var accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func getAllUsers(completion: @escaping ([ExistingUser]) -> Void) {
        
        let getAllUsersRoute: String = "https://pharmacydelivery-production.up.railway.app/api/users"
        
        let headers: HTTPHeaders = [
            .authorization(accessToken)
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            AF.request(getAllUsersRoute, method: .get, encoding: JSONEncoding.default, headers: headers).response { response in
                switch response.data {
                case .some(let data):
                    let json: JSON = JSON(data)
                    if json["statusCode"].stringValue == "200" {
                        let existingUsers = ExistingUser.loadExistingUserArray(jsonArray: json["payload"].arrayValue)
//                        print(existingUsers)
                        
                        completion(existingUsers)
                    }
//                    print(json)
                case .none: print("No data in Get All Users Api Call")
                }
            }
        }
    }
}
