//
//  Room.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/23/23.
//

import SwiftyJSON

struct RoomResponse {
    
    var statusCode: Int!
    var message: String!
    var payload: MCRoom!
    
    static func loadRoomResponse(json: JSON) -> RoomResponse {
        
        var roomResponse = RoomResponse()
        roomResponse.statusCode = json["statusCode"].intValue
        roomResponse.message = json["message"].stringValue
        roomResponse.payload = MCRoom.loadRoom(json: JSON(rawValue: json["payload"].dictionaryValue)!)
        return roomResponse
    }
    
}

struct MCRoom {
    
    var roomName: String!
    var roomSid: String!
    var token: String!
    
    static func loadRoom(json: JSON) -> MCRoom {
        
        var mcroom = MCRoom()
        mcroom.roomName = json["roomName"].stringValue
        mcroom.roomSid = json["roomSid"].stringValue
        mcroom.token = json["token"].stringValue
        return mcroom
    }
}


