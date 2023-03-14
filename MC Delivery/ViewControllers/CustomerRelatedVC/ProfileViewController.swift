//
//  ProfileViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/24/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.setUpUI()
        }
    }
    
    func setUpUI() {
        let name = CredentialsStore.getCredentials()?.user.name
        self.title = name
        self.idLabel.text = CredentialsStore.getCredentials()?.user._id
        self.view.backgroundColor = CustomColor().backgroundColor
    }

}
