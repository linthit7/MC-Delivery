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
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Login"
        return cell
    }
    
    
    
}
