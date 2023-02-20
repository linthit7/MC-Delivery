//
//  MedicineCollectionViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit

class MedicineCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: MedicineCollectionViewCell.self)
    
    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 10
     
        medicineImageView.image = UIImage(systemName: "sdoc.plaintext.fill")
        medicineNameLabel.text = "Medicine"
        priceLabel.text = "5000"
    }

}
