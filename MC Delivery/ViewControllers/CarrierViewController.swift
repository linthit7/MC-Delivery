//
//  CarrierViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/23/23.
//

import UIKit

class CarrierViewController: UIViewController {
    
    private var existingUserList = [ExistingUser]()
    
    @IBOutlet weak var carrierTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carrierTableView.delegate = self
        carrierTableView.dataSource = self
        
        UserRequest(accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzZjg1ZTA3ZjZkYzZhOWI4YTc1ZjI3MSIsImlhdCI6MTY3NzIyOTM0MCwiZXhwIjoxNjc3MzE1NzQwfQ.VuDkThgNwW-759qU6L2d-Krxabo_2lEtlt2SpiQnpzo").getAllUsers() { existingUserList in
            self.existingUserList.append(contentsOf: existingUserList)
            
            DispatchQueue.main.async {
                self.carrierTableView.reloadData()
            }
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
        
        if  AppDelegate.loginState {
            let token = CredentialsStore.getCredentials()?.accessToken
            CreateOrJoinRoomRequest(accessToken: token!).creatOrJoinRoom() { room in
                self.startDemo()
                print("Room", room.token!)
            }
        }
    }
    
}

//MARK: - CallManager

extension CarrierViewController {
    
    func startDemo() {
        
        //Report Incoming Call
//        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
//            let callManger = CallManager()
//            let id = UUID()
//            callManger.reportIncomingCall(id: id, handle: "Travis")
//        })
        
        //Start Call
//        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
//            let callManager = CallManager()
//            let id = UUID()
//            callManager.startCall(id: id, handle: "Scott")
//        })
    }
}
