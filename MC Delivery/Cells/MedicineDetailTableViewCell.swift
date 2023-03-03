//
//  MedicineDetailTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import UIKit

class MedicineDetailTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MedicineDetailTableViewCell.self)
    
    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var medicineInformationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    
    @IBOutlet weak var addToBasketButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func addToBasketButtonPressed(_ sender: UIButton) {
        print("addToBasket")
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        print("plusPressed")
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        print("minusPressed")
    }
    
    func createMedicineDetail(medicine: Medicine) {
        medicineImageView.sd_setImage(with: medicine.pictureUrls[0].url)
        medicineNameLabel.text = medicine.name
        medicineInformationLabel.text = medicine.details
        priceLabel.text = "Ks.\(String(medicine.price))"
    }
    
    
}
