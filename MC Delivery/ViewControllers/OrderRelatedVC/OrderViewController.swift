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
        }
    }
    
    private func setupUI() {
        DispatchQueue.main.async { [self] in
            title = "Past Orders"
            view.backgroundColor = CustomColor().backgroundColor
            orderTableView.backgroundColor = CustomColor().backgroundColor
        }
    }
}

// UITableView Delegate & Datasource Methods

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        cell.createOrderHistoryCell(orderHistory: orderHistoryList[indexPath.row])
        return cell
    }
    
    
}
