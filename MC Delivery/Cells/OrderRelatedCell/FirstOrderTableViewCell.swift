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
        DispatchQueue.main.async {
            self.orderIdLabel.text = "Order #\(String(describing: orderHistory._id!))"
            self.deliverDateLabel.text = "Delivered on \(String(describing: orderHistory.updatedAt!))"
            self.addressLabel.text = "\(String(describing: orderHistory.address!))"
        }
    }
    
}
