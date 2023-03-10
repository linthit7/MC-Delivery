//
//  OrderTotalBillTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/10/23.
//

import UIKit

class OrderTotalBillTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: OrderTotalBillTableViewCell.self)

    @IBOutlet weak var subtotalPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func createOrderTotalBillCell(orderHistory: OrderHistory) {
        
        DispatchQueue.main.async { [self] in
            subtotalPriceLabel.text = "MMK \(orderHistory.totalPrice!)"
            deliveryPriceLabel.text = "MMK 500"
            let discount = Int(Double(orderHistory.totalPrice!)/3)
            discountPriceLabel.layer.cornerRadius = 10
            discountPriceLabel.text = "- MMK \(discount)"
            finalPriceLabel.text = "MMK \(orderHistory.totalPrice! - discount)"
        }
    }
}
