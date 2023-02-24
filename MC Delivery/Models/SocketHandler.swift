//
//  SocketHandler.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/24/23.
//

import Foundation
import SocketIO
import Alamofire

class SocketHandler: NSObject {
    
    static let sharedInstance = SocketHandler()
    
    let socket = SocketManager(socketURL: URL(string: "https://pharmacydelivery-production.up.railway.app")!, config: [.log(true), .compress, .extraHeaders(["token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzZjg1ZTA3ZjZkYzZhOWI4YTc1ZjI3MSIsImlhdCI6MTY3NzIyMjQ3NSwiZXhwIjoxNjc3MzA4ODc1fQ.3W_uzCDyfzL23MgKNo-1F1hKiKeqTDqHEVACgLhuXfs"]), .forceWebsockets(true), .connectParams(["EIO": "3"])])
    
    var mSocket: SocketIOClient!

    override init() {
        super.init()

        mSocket = socket.defaultSocket
    }

    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection(token: String) {
        
//        let socket = SocketManager(socketURL: URL(string: "https://pharmacydelivery-production.up.railway.app")!, config: [.log(true), .compress, .extraHeaders(["token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzZjg1ZTA3ZjZkYzZhOWI4YTc1ZjI3MSIsImlhdCI6MTY3NzIyMjQ3NSwiZXhwIjoxNjc3MzA4ODc1fQ.3W_uzCDyfzL23MgKNo-1F1hKiKeqTDqHEVACgLhuXfs"]), .forceWebsockets(true), .connectParams(["EIO": "3"])])
        mSocket.on(clientEvent: .connect) {_,_ in }
        mSocket.connect()
    }

    func closeConnection() {
        mSocket.disconnect()
    }
    
}
