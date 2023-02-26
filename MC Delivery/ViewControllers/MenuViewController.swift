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
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccesshandler), name: NSNotification.Name("Login Successful"), object: nil)
    }
    
    @objc
    private func loginSuccesshandler() {
        menuListTableView.reloadData()
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        switch indexPath.row {
//        case 0: navigationController?.pushViewController(LoginViewController(), animated: true)
//        case 1: navigationController?.pushViewController(CarrierViewController(), animated: true)
//        default: print("Default case MenuVC didSelectRowAt")
//        }
        
        switch indexPath.row {
        case 0:
            var viewControllerToPush = UIViewController()
            if AppDelegate.loginState {
                viewControllerToPush = ProfileViewController()
            } else {
                viewControllerToPush = LoginViewController()
            }
            navigationController?.pushViewController(viewControllerToPush, animated: true)
        case 1:
            let carrierVC = CarrierViewController()
//            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//            navigationController?.navigationBar.tintColor = UIColor.white
//            navigationController?.pushViewController(medicineDetailVC, animated: true)
            navigationController?.pushViewController(carrierVC, animated: true)
        default: print("Default case MenuVC didSelectRowAt")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch AppDelegate.loginState {
        case true: return 2
        case false: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if AppDelegate.loginState {
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.textLabel?.text = "My Account"
                return cell
            case 1:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Carriers"
                return cell
            default: return UITableViewCell()
            }
        } else {
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Login"
                return cell
            default: return UITableViewCell()
            }
        }
    }
    
    
}
