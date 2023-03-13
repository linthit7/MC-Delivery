//
//  FirstOrderTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/10/23.
//

import UIKit

class FirstOrderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: FirstOrderTableViewCell.self)

    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var deliverDateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createFirstOrderCell(orderHistory: OrderHistory) {
        DispatchQueue.main.async { [self] in
            if orderHistory.status == "cancel" {
                deliverDateLabel.isHidden = true
            }
            orderIdLabel.text = "Order #\(String(describing: orderHistory._id!))"
            deliverDateLabel.text = "Delivered on \(String(describing: orderHistory.updatedAt!))"
            addressLabel.text = "\(String(describing: orderHistory.address!))"
        }
    }
    
}
