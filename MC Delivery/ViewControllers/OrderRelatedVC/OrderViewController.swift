//
//  OrderViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/8/23.
//

import UIKit

class OrderViewController: UIViewController {

    private var orderHistoryList = [OrderHistory]()
    private var pendingOrderList = [OrderHistory]()
    
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
            OrderRequest(accessToken: token!).getPendingOrder { [self] pendingOrder in
                
                self.pendingOrderList.append(contentsOf: pendingOrder)
                DispatchQueue.main.async {
                    self.pendingTableView.reloadData()
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
            return pendingOrderList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == orderTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else { return UITableViewCell()}
            cell.createOrderHistoryCell(orderHistory: orderHistoryList[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else {return UITableViewCell()}
            cell.createOrderHistoryCell(orderHistory: pendingOrderList[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == orderTableView {
            let orderDetailVC = OrderDetailViewController(orderId: orderHistoryList[indexPath.row]._id)
            navigationController?.pushViewController(orderDetailVC, animated: true)
        } else {
            let orderDetailVC = OrderDetailViewController(orderId: pendingOrderList[indexPath.row]._id)
            navigationController?.pushViewController(orderDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
