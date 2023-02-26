//
//  ClientViewController.swift
//  MC Delivery Carrier
//
//  Created by Lin Thit Khant on 2/25/23.
//

import UIKit
import SDWebImage

class ClientViewController: UIViewController {
    
    private var existingUserList = [ExistingUser]()
    var mSocket = SocketHandler.sharedInstance.getSocket()
    var callManager = CallManager()
    
    @IBOutlet weak var clientTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        socketOn()
        
        clientTableView.delegate = self
        clientTableView.dataSource = self
        
        if AppDelegate.loginState {
            let token = CredentialsStore.getCredentials()?.accessToken
            UserRequest(accessToken: token!).getAllUsers() { existingUserList in
                self.existingUserList.append(contentsOf: existingUserList)
                
                DispatchQueue.main.async {
                    self.clientTableView.reloadData()
                }
            }
        }

    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.title = "Client List"
            self.view.backgroundColor = CustomColor().backgroundColor
        }
    }

}

extension ClientViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = existingUserList[indexPath.row].name
        cell.imageView?.image = UIImage(systemName: "phone.fill")?.sd_tintedImage(with: CustomColor().backgroundColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(indexPath)
        
        if  AppDelegate.loginState {
            
            let token = CredentialsStore.getCredentials()?.accessToken
            let caller = CredentialsStore.getCredentials()?.user
            let callee = existingUserList[indexPath.row]
            
            CreateOrJoinRoomRequest(accessToken: token!).creatOrJoinRoom() { room in
                
                let data = [
                    "callerId": caller?._id,
                    "calleeId": callee._id,
                    "roomName": room.roomName
                    ]
                
                self.mSocket.emit("start-call", data) {
                    print("Emitted Start-call", data)
                    
                    let videoVC = VideoCallViewController()
                    self.navigationController?.pushViewController(videoVC, animated: false)
                    self.callManager.startCall(id: UUID(), handle: callee.name)
                }
            }
        }
    }
    
}

extension ClientViewController {
    
    func socketOn() {
        self.mSocket.on("calling") { data, ack in
//            print("Calling", data)
            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String
            let token = dataDic?.value(forKey: "token") as? String
            let caller = dataDic?.value(forKey: "caller") as? NSDictionary
            
//            print(roomName)
//            print(token)
//            print(caller)
            self.callManager.reportIncomingCall(id: UUID(uuidString: roomName!)!, handle: caller?.value(forKey: "name") as! String)
        }
    }
    
}
