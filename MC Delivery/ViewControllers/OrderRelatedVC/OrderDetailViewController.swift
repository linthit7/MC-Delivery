//
//  OrderDetailViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/10/23.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    private var orderHistory = OrderHistory()
    
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var cancelOrderView: UIView!
    
    init(orderHistory: OrderHistory) {
        self.orderHistory = orderHistory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if orderHistory.status == "pending" {
            cancelOrderView.isHidden = false
        } else if orderHistory.status == "deliver" {
            cancelOrderView.isHidden = true
        }
        orderDetailTableView.register(UINib(nibName: FirstOrderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: FirstOrderTableViewCell.reuseIdentifier)
        orderDetailTableView.register(UINib(nibName: MedicineOrderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MedicineOrderTableViewCell.reuseIdentifier)
        orderDetailTableView.register(UINib(nibName: OrderTotalBillTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OrderTotalBillTableViewCell.reuseIdentifier)
        orderDetailTableView.dataSource = self
        orderDetailTableView.delegate = self
        orderDetailTableView.reloadData()
    }
    
    private func setupUI() {
        
        DispatchQueue.main.async { [self] in
            orderDetailTableView.backgroundColor = CustomColor().backgroundColor
            orderDetailTableView.separatorColor = UIColor.clear
            cancelOrderView.layer.shadowOpacity = 0.2
            cancelOrderView.backgroundColor = CustomColor().backgroundColor
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.navigationBar.tintColor = UIColor.white
        }
    }
    @IBAction func cancelOrderButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async { [self] in
            view.makeToastActivity(.center)
            view.alpha = 0.8
        }
        view.isUserInteractionEnabled = false
        navigationController?.view.isUserInteractionEnabled = false
        
        let token = CredentialsStore.getCredentials()?.accessToken
        OrderRequest(accessToken: token!).cancelOrderByOrderId(orderId: orderHistory._id) { [self] in
            navigationController?.popToRootViewController(animated: true)
            
            DispatchQueue.main.async {
                self.view.hideToastActivity()
            }
            view.isUserInteractionEnabled = true
            navigationController?.view.isUserInteractionEnabled = true
        }
    }
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return orderHistory.orderDetails.count + 1
        case 1: return 1
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
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicineOrderTableViewCell.reuseIdentifier, for: indexPath) as?
                        MedicineOrderTableViewCell else {return UITableViewCell()}
                cell.createMedicineOrderCell(orderDetail:                 orderHistory.orderDetails[indexPath.row - 1])
                return cell
            }
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTotalBillTableViewCell.reuseIdentifier, for: indexPath) as? OrderTotalBillTableViewCell else {return UITableViewCell()}
            cell.createOrderTotalBillCell(orderHistory: orderHistory)
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    
}
