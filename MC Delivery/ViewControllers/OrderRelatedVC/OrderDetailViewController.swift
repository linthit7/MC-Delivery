//
//  OrderDetailViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/10/23.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    private let orderId: String
    private var orderHistory = OrderHistory()

    @IBOutlet weak var orderDetailTableView: UITableView!
    
    init(orderId: String) {
        self.orderId = orderId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        if AppDelegate.loginState {
            let token = CredentialsStore.getCredentials()?.accessToken
            OrderRequest(accessToken: token!).getOrderByOrderId(orderId: orderId) { [self] orderHistory in
                
                self.orderHistory = orderHistory
                orderDetailTableView.register(UINib(nibName: FirstOrderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: FirstOrderTableViewCell.reuseIdentifier)
                orderDetailTableView.dataSource = self
                orderDetailTableView.delegate = self
                orderDetailTableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        
        DispatchQueue.main.async { [self] in
            orderDetailTableView.backgroundColor = CustomColor().backgroundColor
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
//        case 0: return orderHistory.orderDetails.count + 1
        case 0: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstOrderTableViewCell.reuseIdentifier, for: indexPath) as? FirstOrderTableViewCell else {return UITableViewCell()}
                cell.createFirstOrderCell(orderHistory: orderHistory)
                return cell
            default: return UITableViewCell()
            }
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    
}
