//
//  OngoingOrderViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/13/23.
//

import UIKit

class OngoingOrderViewController: UIViewController {

    private var ongoingOrderList = [OrderHistory]()
    var mSocket = SocketHandler.sharedInstance.getSocket()
    let callManager = CallManager.sharedInstance
    
    @IBOutlet weak var ongoingOrderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppDelegate.loginState {
            let token = CredentialsStore.getCredentials()?.accessToken
            OrderRequest(accessToken: token!).getOngoingOrder { [self] ongoingOrder in
                ongoingOrderList.append(contentsOf: ongoingOrder)
                ongoingOrderTableView.register(UINib(nibName: OrderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
                ongoingOrderTableView.delegate = self
                ongoingOrderTableView.dataSource = self
                ongoingOrderTableView.reloadData()
            }
        }
        setupUI()
    }
    
    private func setupUI() {
        DispatchQueue.main.async { [self] in
            view.backgroundColor = CustomColor().backgroundColor
            ongoingOrderTableView.backgroundColor = CustomColor().backgroundColor
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
    }
}

//MARK: - UITableView DataSource & UITableView Delegate Methods

extension OngoingOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ongoingOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else {return UITableViewCell()}
        cell.createOrderHistoryCell(orderHistory: ongoingOrderList[indexPath.row], user: "Customer")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailVC = OrderDetailViewController(orderHistory: ongoingOrderList[indexPath.row])
        navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ongoing Orders"
    }
    
}
