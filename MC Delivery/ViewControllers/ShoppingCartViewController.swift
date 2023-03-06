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
        shoppingCartTableView.register(UINib(nibName: MedicineTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MedicineTableViewCell.reuseIdentifier)
        shoppingCartTableView.delegate = self
        shoppingCartTableView.dataSource = self
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

//MARK: - UITableViewDelegate & DataSource Methods

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = shoppingCartTableView.dequeueReusableCell(withIdentifier: MedicineTableViewCell.reuseIdentifier, for: indexPath) as? MedicineTableViewCell else {
            return UITableViewCell()
        }
        cell.medicineImageView.image = UIImage(systemName: "square.and.arrow.up")
        cell.titleLabel.text = "Dummy Medicine"
        cell.priceLabel.text = "7000"
        return cell
    }
    
    
}

