//
//  MedicineDetailTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import UIKit

class MedicineDetailTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: MedicineDetailViewController.self)
    
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
    
    
}
