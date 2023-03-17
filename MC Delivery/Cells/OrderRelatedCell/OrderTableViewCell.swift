//
//  OrderTableViewCell.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/9/23.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: OrderTableViewCell.self)

    @IBOutlet weak var pharmacyLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var callDeliveryPersonButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func callDeliveryPersonButtonPressed(_ sender: UIButton) {
        
        let token = CredentialsStore.getCredentials()?.accessToken
        let caller = CredentialsStore.getCredentials()?.user
    }
    
    func createOrderHistoryCell(orderHistory: OrderHistory) {
        DispatchQueue.main.async { [self] in
            pharmacyLabel.text = "MyanCare Pharmacy"
            totalPriceLabel.text = "MMK \(String(describing: orderHistory.totalPrice!))"
            if orderHistory.status == "cancel" {
                let url = URL(string: orderHistory.orderDetails[0].medicine.pictureUrls[0].stringValue)
                medicineImageView.sd_setImage(with: url)
                let frontImg = UIImage(named: "cancellation.jpg")
                let frontView = UIImageView(image: frontImg)
                frontView.frame = medicineImageView.frame
                frontView.alpha = 0.4
                medicineImageView.addSubview(frontView)
            } else if orderHistory.status == "deliver" {
                callDeliveryPersonButton.setTitle("", for: .normal)
                callDeliveryPersonButton.isHidden = false
                let url = URL(string: orderHistory.orderDetails[0].medicine.pictureUrls[0].stringValue)
                medicineImageView.sd_setImage(with: url)
            } else {
                let url = URL(string: orderHistory.orderDetails[0].medicine.pictureUrls[0].stringValue)
                medicineImageView.sd_setImage(with: url)
            }
            medicineLabel.text = OrderHistoryLogic().getAllMedicineName(orderHistory: orderHistory).joined(separator: ", ")
        }
    }
    
}
