//
//  ShoppingCartViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/6/23.
//

import UIKit
import Toast_Swift

class ShoppingCartViewController: UIViewController {
    
    var shoppingCartItem: [Med]!
    var address: String!

    @IBOutlet weak var shoppingCartTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var proceedToCheckoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        shoppingCartTableView.register(UINib(nibName: MedicineTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MedicineTableViewCell.reuseIdentifier)
        shoppingCartTableView.delegate = self
        shoppingCartTableView.dataSource = self
        shoppingCartItem = ShoppingCart.sharedInstance.fetchAllItem()
        shoppingCartTableView.reloadData()
    }

    @IBAction func proccedToCheckoutButtonPressed(_ sender: UIButton) {
        
        if proceedToCheckoutButton.titleLabel?.text == "Proceed To Checkout" {
            let locationVC = LocationViewController()
            locationVC.delegate = self
            present(locationVC, animated: true)
        } else {
            DispatchQueue.main.async {
                self.view.makeToastActivity(.center)
                self.view.alpha = 0.8
            }
            view.isUserInteractionEnabled = false
            navigationController?.view.isUserInteractionEnabled = false
            
            let accessToken = (CredentialsStore.getCredentials()?.accessToken)!
            ShoppingCartLogic.medToOrder(meds: shoppingCartItem) { [self] order in
                
                OrderRequest(accessToken: accessToken).placeOrder(order: order, address: address) {
                    
                    ShoppingCartLogic.orderCleanUp {
                        
                        DispatchQueue.main.async {
                            self.view.hideToastActivity()
                        }
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.view.isUserInteractionEnabled = true
                    }
                }
            }
        }
        
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.title = "Shopping Cart"
            self.proceedToCheckoutButton.setTitle("Proceed To Checkout", for: .normal)
            self.view.backgroundColor = CustomColor().backgroundColor
            self.shoppingCartTableView.backgroundColor = CustomColor().backgroundColor
            self.totalAmountLabel.text = "Total Amount: \(ShoppingCartLogic.totalAmount(meds: self.shoppingCartItem)) Ks"
            self.proceedToCheckoutButton.tintColor = CustomColor().buttonColor
        }
    }

}

//MARK: - UITableViewDelegate & DataSource Methods

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCartItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicineTableViewCell.reuseIdentifier, for: indexPath) as? MedicineTableViewCell else {
            return UITableViewCell()
        }
        cell.createMedicineCell(medicine: shoppingCartItem[indexPath.row], currentIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
                ShoppingCart.sharedInstance.removeItemFromPersistentStore(item: shoppingCartItem[indexPath.row])
                tableView.beginUpdates()
                self.shoppingCartItem.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                totalAmountLabel.text = "Total Amount: \(ShoppingCartLogic.totalAmount(meds: self.shoppingCartItem)) Ks"
        }
    }
    
}

extension ShoppingCartViewController: MyDataSendingDelegateProtocol {
    
    func sendDataToFirstViewController(myData: String) {
        
        DispatchQueue.main.async {
            self.proceedToCheckoutButton.setTitle("Checkout", for: .normal)
        }
        address = myData
    }
    
    
}
