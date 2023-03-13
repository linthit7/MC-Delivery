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
    
    func validateWithEmailAndPassword(completion: @escaping (LoginResponse) -> Void) {
        
        let loginRoute = "https://pharmacydelivery-production.up.railway.app/api/auth/login"
        
        let params: Parameters = [
            "email": email,
            "password": password
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(loginRoute, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { response in
                switch response.data {
                case .some(let data):
                    let json: JSON = JSON(data)
                    let loginResponse = LoginResponse.loadLoginResponse(json: json)
                    completion(loginResponse)
                case .none: print("No response from login route.")
                }
            }
        }
    }
}
