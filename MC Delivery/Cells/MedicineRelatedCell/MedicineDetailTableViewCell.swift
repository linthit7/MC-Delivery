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
        ShoppingCart.sharedInstance.saveItemToPersistentStore(item: medicine, quantity: count) {
            NotificationCenter.default.post(name: ShoppingCart.Alert.addedToPersistentStore.rawValue, object: nil)
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        if count < medicine.stocks {
            count += 1
            DispatchQueue.main.async { [self] in
                itemCountLabel.text = String(count)
            }
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        if count > 1 {
            count -= 1
            DispatchQueue.main.async { [self] in
                itemCountLabel.text = String(count)
            }
        }
    }
    
    func createMedicineDetail(medicine: Medicine) {
        DispatchQueue.main.async { [self] in
            medicineImageView.sd_setImage(with: medicine.pictureUrls[0].url)
            medicineNameLabel.text = medicine.name
            medicineInformationLabel.text = medicine.details
            priceLabel.text = "MMK\(String(medicine.price))"
            addToBasketButton.tintColor = CustomColor().buttonColor
            if medicine.stocks == 0 {
                itemCountLabel.text = "Out of stock"
                itemCountLabel.textColor = UIColor.red
                plusButton.isHidden = true
                minusButton.isHidden = true
                addToBasketButton.isHidden = true
            } else {
                itemCountLabel.text = String(count)
            }
        }
        self.medicine = medicine
    }
    
    
}
