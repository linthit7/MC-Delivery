//
//  MedicineOrderTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/10/23.
//

import UIKit

class MedicineOrderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MedicineOrderTableViewCell.self)

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createMedicineOrderCell(orderDetail: OrderDetails) {
        
        DispatchQueue.main.async { [self] in
            quantityLabel.text = "\(String(describing: orderDetail.quantity!))x"
            medicineLabel.text = orderDetail.medicine.name!
            priceLabel.text = "MMK \(String(orderDetail.medicine.price!))"
        }
    }

}
