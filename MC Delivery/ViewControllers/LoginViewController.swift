//
//  LoginViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.view.backgroundColor = CustomColor().backgroundColor
            self.title = "Login"
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

}
