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
    
    let socket = SocketManager(socketURL: URL(string: "https://pharmacydelivery-production.up.railway.app")!, config: [.compress, .extraHeaders(["token": CredentialsStore.getCredentials()!.accessToken]), .forceWebsockets(true), .connectParams(["EIO": "3"])])
    
    var mSocket: SocketIOClient!

    override init() {
        super.init()

        mSocket = socket.defaultSocket
    }

    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection(token: String) {

        mSocket.on(clientEvent: .connect) { data, ack in
            print("Socket connected", data, ack)
        }
        mSocket.connect()
    }

    func closeConnection() {
        mSocket.disconnect()
    }
    
}
