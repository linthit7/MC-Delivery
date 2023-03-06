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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
    }
}
