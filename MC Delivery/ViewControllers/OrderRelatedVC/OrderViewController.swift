//
//  OrderViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/8/23.
//

import UIKit

class OrderViewController: UIViewController {

    private var orderHistoryList = [OrderHistory]()
    
    @IBOutlet weak var orderTableView: UITableView!
    
    @IBOutlet weak var pendingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        if AppDelegate.loginState {
            let token = CredentialsStore.getCredentials()?.accessToken
            OrderRequest(accessToken: token!).getPastOrderWithCompleteAndCancel() { [self] orderHistory in
                
                self.orderHistoryList.append(contentsOf: orderHistory)
                DispatchQueue.main.async {
                    self.orderTableView.reloadData()
                }
            }
        }
        
        DispatchQueue.main.async { [self] in
            orderTableView.register(UINib(nibName: OrderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
            orderTableView.delegate = self
            orderTableView.dataSource = self
            pendingTableView.register(UINib(nibName: OrderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
            pendingTableView.delegate = self
            pendingTableView.dataSource = self
        }
    }
    
    private func setupUI() {
        DispatchQueue.main.async { [self] in
            title = "Orders"            
            view.backgroundColor = CustomColor().backgroundColor
            orderTableView.backgroundColor = CustomColor().backgroundColor
            pendingTableView.backgroundColor = CustomColor().backgroundColor
        }
    }
}

// UITableView Delegate & Datasource Methods

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == orderTableView {
            return "Past Orders"
        } else {
            return "Pending Orders"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderTableView {
            return orderHistoryList.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == orderTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else { return UITableViewCell()}
            cell.createOrderHistoryCell(orderHistory: orderHistoryList[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else {return UITableViewCell()}
            cell.medicineLabel.text = "dummy"
            return cell
        }
        return UITableViewCell()
    }
    
    
}
