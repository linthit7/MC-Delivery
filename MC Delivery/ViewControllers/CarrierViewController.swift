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
        
        UserRequest(accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzZjVjNmQ4YjE0MWIxODdkZTQ4Y2Q0YyIsImlhdCI6MTY3NzEyMzg2NSwiZXhwIjoxNjc3MjEwMjY1fQ.EEPSgoSzx_tikQbw4sMjQWjNdMOpsIgDZcXonyVK3pM").getAllUsers() { existingUserList in
            self.existingUserList.append(contentsOf: existingUserList)
            print(self.existingUserList)
            
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
        print(existingUserList[indexPath.row].name)
    }
    
}
