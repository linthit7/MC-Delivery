//
//  LoginViewController.swift
//  MC Delivery Carrier
//
//  Created by Lin Thit Khant on 2/25/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(popThisViewController), name: NSNotification.Name("Login Successful"), object: nil)
        
        DispatchQueue.main.async {
            self.view.backgroundColor = CustomColor().backgroundColor
            self.title = "Login"
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        emailTextField.text = "testcapybara@gmail.com"
        passwordTextField.text = "test1234"
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print(self.emailTextField.text!)
        print(self.passwordTextField.text!)
        let authLogic = AuthRequest(email: emailTextField.text!, password: passwordTextField.text!)
        authLogic.validateWithEmailAndPassword() { loginResponse in
        
            CredentialsStore.storeCredentials(payload: loginResponse.payload)
        }
        
    }
    
    @objc
    private func popThisViewController() {
        navigationController?.popViewController(animated: true)
    }
    

}
