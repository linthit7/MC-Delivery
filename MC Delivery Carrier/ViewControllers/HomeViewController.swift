//
//  HomeViewController.swift
//  MC Delivery Carrier
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    var mSocket = SocketHandler.sharedInstance.getSocket()
    var callManager = CallManager()
    var room = MCRoom()
    
    private let customButton = CustomButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectVideoCall), name: NSNotification.Name(rawValue: "AnswerCall"), object: nil)
        
        DispatchQueue.main.async {
            self.view.backgroundColor = CustomColor().backgroundColor
            self.title = "MyanCare Carrier"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.standardAppearance = CustomNavigationBar().navBar
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = self.customButton.menuButton
        }
        customButton.menuButton.target = self
        customButton.menuButton.action = #selector(menuButtonPressed)
        
        mSocket.on("calling") { data, ack in
            
            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String
            let token = dataDic?.value(forKey: "token") as? String
            let caller = dataDic?.value(forKey: "caller") as? NSDictionary
            
            self.room.roomName = roomName
            self.room.token = token
            
            self.callManager.reportIncomingCall(id: UUID(uuidString: roomName!)!, handle: caller?.value(forKey: "name") as! String)
        }
        mSocket.on("acceptCall") { data, ack in

            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String

//            self.callManager.performAnswerCallAction(id: UUID(uuidString: roomName!)!)
        }
    }
    
    @objc
    private func menuButtonPressed() {
        let menu = SideMenuNavigationController(rootViewController: MenuViewController())
        menu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        present(menu, animated: true, completion: nil)
    }
    
    @objc
    private func connectVideoCall() {
        
        let caller = CredentialsStore.getCredentials()?.user
        let callee =
        CalleeStore.getCallee()
            
        let data = [
            "callerId": callee?._id,
            "calleeId": caller?._id,
            "roomName": room.roomName
        ]
        
        mSocket.emit("acceptCall", data) {
        }
        
        let videoVC = VideoCallViewController(socketRoom: room)
        navigationController?.pushViewController(videoVC, animated: true)
    }

}
