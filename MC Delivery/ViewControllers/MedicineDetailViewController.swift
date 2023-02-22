//
//  MedicineDetailViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import UIKit

class MedicineDetailViewController: UIViewController {
    
    var medicine: Medicine!
    
    @IBOutlet weak var medicineDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor().backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(shoppingCartButtonPressed))
        
        print(medicine!)
    }
    
    @objc
    private func shoppingCartButtonPressed() {
        print("Shopping Cart Button Pressed")
    }
    
}

extension MedicineDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}

