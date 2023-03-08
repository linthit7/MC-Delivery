//
//  OrderViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/8/23.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        orderTableView.delegate = self
        orderTableView.dataSource = self
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.title = "Orders"
            self.view.backgroundColor = CustomColor().backgroundColor
            self.orderTableView.backgroundColor = CustomColor().backgroundColor
        }
    }

}

// UITableView Delegate & Datasource Methods

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
