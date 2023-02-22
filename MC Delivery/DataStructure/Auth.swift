//
//  Auth.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import SwiftyJSON

struct LoginResponse {
    
    var statusCode: Int!
    var message: String!
    var payload: Payload!
    
    static func loadLoginResponse(json: JSON) -> LoginResponse {
        var loginResponse = LoginResponse()
        loginResponse.statusCode = json["statusCode"].intValue
        loginResponse.message = json["message"].stringValue
        loginResponse.payload = Payload.loadPayload(json: JSON(rawValue: json["payload"].dictionaryValue)!)
        return loginResponse
    }
}

struct Payload {
    
    var user: User!
    var accessToken: String!
    
    static func loadPayload(json: JSON) -> Payload {
        var payload = Payload()
        payload.user = User.loadUser(json: JSON(rawValue: json["user"].dictionaryValue)!)
        payload.accessToken = json["accessToken"].stringValue
        return payload
    }
}

struct User {
    
    var _id: String!
    var id: String!
    var name: String!
    var email: String!
    var password: String!
    var pictureUrls: [JSON]!
    var picPublicIds: [JSON]!
    var isTwoFactor: Bool!
    var phoneNumber: String!
    var favouriteMedicines: [JSON]!
    var createdAt: String!
    var updatedAt: String!
    
    static func loadUser(json: JSON) -> User {
        
        var user = User()
        user._id = json["_id"].stringValue
        user.id = json["id"].stringValue
        user.name = json["name"].stringValue
        user.email = json["email"].stringValue
        user.password = json["password"].stringValue
        user.pictureUrls = json["pictureUrls"].arrayValue
        user.picPublicIds = json["picPublicIds"].arrayValue
        user.isTwoFactor = json["isTwoFactor"].boolValue
        user.phoneNumber = json["phoneNumber"].stringValue
        user.favouriteMedicines = json["favouriteMedicines"].arrayValue
        user.createdAt = json["createdAt"].stringValue
        user.updatedAt = json["updatedAt"].stringValue
        return user
    }
}
