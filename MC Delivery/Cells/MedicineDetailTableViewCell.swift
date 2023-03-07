//
//  MedicineDetailTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import UIKit

class MedicineDetailTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MedicineDetailTableViewCell.self)
    
    private var medicine: Medicine!
    private var count: Int = 1
    
    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var medicineInformationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var addToBasketButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func addToBasketButtonPressed(_ sender: UIButton) {
//        ShoppingCart.sharedInstance.saveItemToPersistentStore(item: medicine, quantity: )
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        print(medicine.orderCount)
        if count < medicine.orderCount {
            count += 1
            DispatchQueue.main.async {
                self.itemCountLabel.text = String(self.count)
            }
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        if count > 1 {
            count -= 1
            DispatchQueue.main.async {
                self.itemCountLabel.text = String(self.count)
            }
        }
    }
    
    func createMedicineDetail(medicine: Medicine) {
        DispatchQueue.main.async {
            self.medicineImageView.sd_setImage(with: medicine.pictureUrls[0].url)
            self.medicineNameLabel.text = medicine.name
            self.medicineInformationLabel.text = medicine.details
            self.priceLabel.text = "Ks.\(String(medicine.price))"
            if medicine.orderCount == 0 {
                self.itemCountLabel.text = "Out of stock"
                self.itemCountLabel.textColor = UIColor.red
                self.plusButton.isHidden = true
                self.minusButton.isHidden = true
                self.addToBasketButton.isHidden = true
            } else {
                self.itemCountLabel.text = String(self.count)
            }
        }
        self.medicine = medicine
    }
    
    
}
