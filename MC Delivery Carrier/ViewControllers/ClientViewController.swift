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
                //  print("Room", room.token!)
                //  Don't forget to get id for call.
                self.callManager.startCall(id: UUID(), handle: callee.name)
                self.mSocket.emit("start-call") {
                    print("start-call emitted")
                }
            }
        }
    }
    
}