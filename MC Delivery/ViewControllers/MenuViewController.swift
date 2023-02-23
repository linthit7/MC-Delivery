//
//  MenuViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuListTableView.dataSource = self
        menuListTableView.delegate = self
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: navigationController?.pushViewController(LoginViewController(), animated: true)
        case 1: navigationController?.pushViewController(CarrierViewController(), animated: true)
        default: print("Default case MenuVC didSelectRowAt")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Login"
            return cell
        case 1:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Users"
            return cell
        default: return UITableViewCell()
        }
    }
    
    
    
}
