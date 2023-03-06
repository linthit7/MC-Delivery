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
        print(MedicineDetailViewController.self, ":Add to bask button pressed.")
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        print(MedicineDetailViewController.self, ":Plus button pressed.")
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        print(MedicineDetailViewController.self, ":Minus button pressed.")
    }
    
    func createMedicineDetail(medicine: Medicine) {
        DispatchQueue.main.async {
            self.medicineImageView.sd_setImage(with: medicine.pictureUrls[0].url)
            self.medicineNameLabel.text = medicine.name
            self.medicineInformationLabel.text = medicine.details
            self.priceLabel.text = "Ks.\(String(medicine.price))"
        }
    }
    
    
}
