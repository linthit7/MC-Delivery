//
//  AuthRequest.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import Alamofire
import SwiftyJSON

struct AuthRequest {
    
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func validateWithEmailAndPassword() {
        
        let loginRoute = "https://pharmacy-delivery.onrender.com/api/auth/login"
        
        let params: Parameters = [
            "email": email,
            "password": password
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(loginRoute, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { response in
                switch response.data {
                case .some(let data):
                    let json: JSON = JSON(data)
//                    print(json)
//                    print(LoginResponse.loadLoginResponse(json: json))
                    let loginResponse = LoginResponse.loadLoginResponse(json: json)
//                    print(loginResponse)
//                    print(loginResponse.payload.user._id)
//                    print(loginResponse.payload.user.picPublicIds[0].stringValue)
//                    print(loginResponse.payload.accessToken)
                case .none: print("No response from login route.")
                }
            }
        }
    }
}
