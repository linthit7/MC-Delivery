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
        
        emailTextField.text = "testyesir@gmail.com"
        passwordTextField.text = "12345678"
        
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print(self.emailTextField.text!)
        print(self.passwordTextField.text!)
        let authLogic = AuthRequest(email: emailTextField.text!, password: passwordTextField.text!)
        authLogic.validateWithEmailAndPassword()
    }
}
