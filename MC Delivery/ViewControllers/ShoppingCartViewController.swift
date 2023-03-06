//
//  ShoppingCartViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/6/23.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    @IBOutlet weak var shoppingCartTableView: UITableView!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.title = "Shopping Cart"
            self.view.backgroundColor = CustomColor().backgroundColor
        }
    }

    @IBAction func proccedToCheckoutButtonPressed(_ sender: UIButton) {
        
    }
    
    
}
