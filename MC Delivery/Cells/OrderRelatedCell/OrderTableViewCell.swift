//
//  OrderTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/9/23.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: OrderTableViewCell.self)

    @IBOutlet weak var pharmacyLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var medicineImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
}
