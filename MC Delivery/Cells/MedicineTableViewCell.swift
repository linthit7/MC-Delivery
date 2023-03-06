//
//  MedicineTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/6/23.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MedicineTableViewCell.self)

    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        print(MedicineTableViewCell.self, ":Remove button pressed.")
    }
    
    func createMedicineCell(medicine: Med) {
        let url = medicine.pictureUrls!
        medicineImageView.sd_setImage(with: URL(string: url))
        titleLabel.text = medicine.name
        priceLabel.text = "Ks. \(medicine.price)"
        quantityLabel.text = "\(medicine.quantity)"
    }
}
