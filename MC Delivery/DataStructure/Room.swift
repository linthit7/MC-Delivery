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
    
    var existingRoom: ExistingRoom!
    var token: String!
    
    static func loadRoom(json: JSON) -> Room {
        
        var room = Room()
        room.existingRoom = ExistingRoom.loadExistingRoom(json: JSON(rawValue: json["existingRoom"].dictionaryValue)!)
        room.token = json["token"].stringValue
        return room
    }
}

struct ExistingRoom {
    
    var sid: String!
    var status: String!
    var dateCreated: String!
    var dateUpdated: String!
    var accountSid: String!
    var enableTurn: String!
    var uniqueName: String!
    var statusCallback: NSNull!
    var statusCallbackMethod: String!
    var endTime: NSNull!
    var duration: NSNull!
    var type: String!
    var maxParticipants: Int!
    var maxParticipantDuration: Int!
    var maxConcurrentPublishedTracks: Int!
    var recordParticipantsOnConnect: Bool!
    var videoCodecs: NSNull!
    var mediaRegion: NSNull!
    var audioOnly: Bool!
    var emptyRoomTimeout: Int!
    var unusedRoomTimeout: Int!
    var largeRoom: Bool!
    var url: String!
    var links: Link!
    
    static func loadExistingRoom(json: JSON) -> ExistingRoom {
        
        var existingRoom = ExistingRoom()
        existingRoom.sid = json["sid"].stringValue
        existingRoom.status = json["status"].stringValue
        existingRoom.dateCreated = json["dateCreated"].stringValue
        existingRoom.dateUpdated = json["dateUpdated"].stringValue
        existingRoom.accountSid = json["accountSid"].stringValue
        existingRoom.enableTurn = json["enableTurn"].stringValue
        existingRoom.uniqueName = json["uniqueName"].stringValue
        existingRoom.statusCallback = json["statusCallback"].null
        existingRoom.statusCallbackMethod = json["statusCallbackMethod"].stringValue
        existingRoom.endTime = json["endTime"].null
        existingRoom.duration = json["duration"].null
        existingRoom.type = json["type"].stringValue
        existingRoom.maxParticipants = json["maxParticipants"].intValue
        existingRoom.maxParticipantDuration = json["maxParticipantDuration"].intValue
        existingRoom.maxConcurrentPublishedTracks = json["maxConcurrentPublishedTracks"].intValue
        existingRoom.recordParticipantsOnConnect = json["recordParticipantsOnConnect"].boolValue
        existingRoom.videoCodecs = json["videoCodecs"].null
        existingRoom.mediaRegion = json["mediaRegion"].null
        existingRoom.audioOnly = json["audioOnly"].boolValue
        existingRoom.emptyRoomTimeout = json["emptyRoomTimeout"].intValue
        existingRoom.unusedRoomTimeout = json["unusedRoomTimeout"].intValue
        existingRoom.largeRoom = json["largeRoom"].boolValue
        existingRoom.url = json["url"].stringValue
        existingRoom.links = Link.loadLink(json: JSON(rawValue: json["links"].dictionaryValue)!)
        return existingRoom
    }
}

struct Link {
    
    var recordings: String!
    var participants: String!
    var recording_rules: String!
    
    static func loadLink(json: JSON) -> Link {
        
        var link = Link()
        link.recordings = json["recordings"].stringValue
        link.participants = json["participants"].stringValue
        link.recording_rules = json["recording_rules"].stringValue
        return link
    }
}
