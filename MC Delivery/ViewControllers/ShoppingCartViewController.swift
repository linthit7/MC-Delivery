//
//  ShoppingCartViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/6/23.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    var shoppingCartItem: [Med]!

    @IBOutlet weak var shoppingCartTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        shoppingCartTableView.register(UINib(nibName: MedicineTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MedicineTableViewCell.reuseIdentifier)
        shoppingCartTableView.delegate = self
        shoppingCartTableView.dataSource = self
        shoppingCartItem = ShoppingCart.sharedInstance.fetchAllItem()
        shoppingCartTableView.reloadData()
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.title = "Shopping Cart"
            self.view.backgroundColor = CustomColor().backgroundColor
            self.shoppingCartTableView.backgroundColor = CustomColor().backgroundColor
        }
    }

    @IBAction func proccedToCheckoutButtonPressed(_ sender: UIButton) {
        print(ShoppingCartViewController.self, "Proceed to checkout button pressed.")
    }
}

//MARK: - UITableViewDelegate & DataSource Methods

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCartItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = shoppingCartTableView.dequeueReusableCell(withIdentifier: MedicineTableViewCell.reuseIdentifier, for: indexPath) as? MedicineTableViewCell else {
            return UITableViewCell()
        }
        cell.createMedicineCell(medicine: shoppingCartItem[indexPath.row])
        return cell
    }
    
}

