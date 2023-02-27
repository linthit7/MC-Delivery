//
//  SocketEventHandler.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/26/23.
//

import Foundation
import CallKit

//struct SocketEventHandler {
//
//    var mSocket = SocketHandler.sharedInstance.getSocket()
//    var callManager = CallManager()
//    
//    func onCalling() {
//
//        mSocket.on("calling") { data, ack in
//
//            let dataDic = data[0] as? NSDictionary
//            let roomName = dataDic?.value(forKey: "roomName") as? String
//            let token = dataDic?.value(forKey: "token") as? String
//            let caller = dataDic?.value(forKey: "caller") as? NSDictionary
//
//            callManager.reportIncomingCall(id: UUID(uuidString: roomName!)!, handle: caller?.value(forKey: "name") as! String)
//        }
//    }
//}
