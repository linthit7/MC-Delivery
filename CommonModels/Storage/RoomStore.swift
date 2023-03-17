//
//  RoomStore.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/17/23.
//

import Foundation

struct RoomStore {
    
    static func storeRoom(room: MCRoom, completion: @escaping() -> Void) {
        
        do {
            let standardUserDefaults = UserDefaults.standard
            let data = try JSONEncoder().encode(room)
            standardUserDefaults.set(data, forKey: "Room")
        } catch {
            print("Error storing room to userdefaults")
        }
        completion()
    }
    
    static func getRoom() -> MCRoom? {
        
        let standardUserDefaults = UserDefaults.standard
        
        if let credentials = standardUserDefaults.data(forKey: "Room") {
            do {
                let data = try
                JSONDecoder().decode(MCRoom.self, from: credentials)
                return data
            } catch {
                print("Error getting room from userdefaults")
            }
        }
        return nil
    }
}
