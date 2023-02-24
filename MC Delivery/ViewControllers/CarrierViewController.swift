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
        
        UserRequest(accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzZjU4MzU0MzRiM2EyMDY1NDQ0NWRiZCIsImlhdCI6MTY3NzIxMzg0OSwiZXhwIjoxNjc3MzAwMjQ5fQ.9Q-jbzJiuYCxM5gtvbmMA_bkN5hAJBE8zWoeHbTgdW4").getAllUsers() { existingUserList in
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
        CreateOrJoinRoomRequest(accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzZjU4MzU0MzRiM2EyMDY1NDQ0NWRiZCIsImlhdCI6MTY3NzIwNTY2MCwiZXhwIjoxNjc3MjkyMDYwfQ.ehQ8qd8tKAef0eRB2FQ_8tCmd8AZHYDCB0VIJTDEUfw", roomName: "AAA").creatOrJoinRoom() { room in
            
//            print(room.existingRoom.sid)
//            print(room.token!)
        }
    }
    
}
