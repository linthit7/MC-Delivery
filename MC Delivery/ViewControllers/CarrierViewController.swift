//
//  CarrierViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/23/23.
//

import UIKit

class CarrierViewController: UIViewController {
    
    private var existingUserList = [ExistingUser]()
    var mSocket = SocketHandler.sharedInstance.getSocket()
    var callManger = CallManager()
    
    @IBOutlet weak var carrierTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        carrierTableView.delegate = self
        carrierTableView.dataSource = self
        
        if AppDelegate.loginState {
            let token = CredentialsStore.getCredentials()?.accessToken
            UserRequest(accessToken: token!).getAllUsers() { existingUserList in
                self.existingUserList.append(contentsOf: existingUserList)
                
                DispatchQueue.main.async {
                    self.carrierTableView.reloadData()
                }
            }
        }
        
        
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.title = "Carrier List"
            self.view.backgroundColor = CustomColor().backgroundColor
        }
    }
    
}

extension CarrierViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = existingUserList[indexPath.row].name
        cell.imageView?.image = UIImage(systemName: "phone.fill")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(indexPath)
        
        if  AppDelegate.loginState {
            
            let token = CredentialsStore.getCredentials()?.accessToken
            let caller = CredentialsStore.getCredentials()?.user
            let callee = existingUserList[indexPath.row]
            
            CreateOrJoinRoomRequest(accessToken: token!).creatOrJoinRoom() { room in
                //                print("Room", room.token!)
                self.callManger.startCall(id: UUID(), handle: callee.name)
                
                self.mSocket.emit("start-call") {
                    print("start-call emitted")
                }
            }
        }
    }
    
}

