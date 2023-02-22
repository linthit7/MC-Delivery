//
//  MedicineDetailViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import UIKit

class MedicineDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor().backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(shoppingCartButtonPressed))
    }
    
    @objc
    private func shoppingCartButtonPressed() {
        print("Shopping Cart Button Pressed")
    }

}
