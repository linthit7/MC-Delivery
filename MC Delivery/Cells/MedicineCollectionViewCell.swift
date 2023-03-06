//
//  MedicineCollectionViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit
import SDWebImage

class MedicineCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: MedicineCollectionViewCell.self)
    
    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 10
    }
    
    func createMedicineCell(medicine: Medicine) {
        let url = medicine.pictureUrls[0].url
        DispatchQueue.main.async {
            self.medicineImageView.sd_setImage(with: url)
            self.medicineNameLabel.text = medicine.name
            self.priceLabel.text = "Ks. \(medicine.price!)"
        }
    }

}
