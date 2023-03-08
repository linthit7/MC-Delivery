//
//  LocationViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/8/23.
//

import UIKit

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(myData: String)
}

class LocationViewController: UIViewController {
    
    var delegate: MyDataSendingDelegateProtocol?
    
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if self.delegate != nil && self.addressTextField.text != nil {
            let dataToBeSent = self.addressTextField.text
            self.delegate?.sendDataToFirstViewController(myData: dataToBeSent!)
            dismiss(animated: true)
        }
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.view.backgroundColor = CustomColor().backgroundColor
            self.addressTextField.text = "No(10). Thuta Myaing, Theintgayha Avenue, Myeik."
        }
        isModalInPresentation = true
    }
    
}
