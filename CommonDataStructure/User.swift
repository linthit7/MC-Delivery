//
//  User.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import SwiftyJSON

struct UserResponse {
    
    var statusCode: Int!
    var payload: [ExistingUser]!
    var documentCount: Int!
    var message: String!
    
    static func loadUserResponse(json: JSON) -> UserResponse {
        
        var userResponse = UserResponse()
        userResponse.statusCode = json["statusCode"].intValue
//        userResponse.payload = ExistingUser.loadExistingUserArray(jsonArray: json["payload"].arrayValue)
        userResponse.documentCount = json["documentCount"].intValue
        userResponse.message = json["message"].stringValue
        return userResponse
    }
}

struct ExistingUser: Codable {
    
    var _id: String!
    var id: String!
    var name: String!
    var email: String!
    var pictureUrls: [JSON]!
    var picPublicIds: [JSON]!
    var isTwoFactor: Bool!
    var phoneNumber: String!
    var createdAt: String!
    var updatedAt: String!
    var roleType: String!
    var favouriteMedicines: [JSON]!
    
    static func loadExistingUser(json: JSON) -> ExistingUser {
        
        var existingUser = ExistingUser()
        existingUser._id = json["_id"].stringValue
        existingUser.id = json["id"].stringValue
        existingUser.name = json["name"].stringValue
        existingUser.email = json["email"].stringValue
        existingUser.pictureUrls = json["pictureUrls"].arrayValue
        existingUser.picPublicIds = json["picPublicIds"].arrayValue
        existingUser.isTwoFactor = json["isTwoFactor"].boolValue
        existingUser.phoneNumber = json["phoneNumber"].stringValue
        existingUser.createdAt = json["createdAt"].stringValue
        existingUser.updatedAt = json["updatedAt"].stringValue
        existingUser.roleType = json["roleType"].stringValue
        existingUser.favouriteMedicines = json["favouriteMedicines"].arrayValue
        return existingUser
    }
    
    static func loadExistingUserArray(jsonArray: [JSON]) -> [ExistingUser] {
        
        var existingUserArray: [ExistingUser] = []
        for json in jsonArray {
            let existingUser = ExistingUser.loadExistingUser(json: json)
            existingUserArray.append(existingUser)
        }
        return existingUserArray
    }
}
