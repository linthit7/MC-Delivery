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
    var payload: Room!
    
    static func loadRoomResponse(json: JSON) -> RoomResponse {
        
        var roomResponse = RoomResponse()
        roomResponse.statusCode = json["statusCode"].intValue
        roomResponse.message = json["message"].stringValue
        roomResponse.payload = Room.loadRoom(json: JSON(rawValue: json["payload"].dictionaryValue)!)
        return roomResponse
    }
    
}

struct Room {
    
    var roomName: String!
    var roomSid: String!
    var token: String!
    
    static func loadRoom(json: JSON) -> Room {
        
        var room = Room()
        room.roomName = json["roomName"].stringValue
        room.roomSid = json["roomSid"].stringValue
        room.token = json["token"].stringValue
        return room
    }
}


