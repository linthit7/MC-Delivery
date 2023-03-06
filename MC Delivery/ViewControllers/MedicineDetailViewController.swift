//
//  MedicineDetailViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import UIKit

class MedicineDetailViewController: UIViewController {
    
    private let medicine: Medicine
    
    init(medicine: Medicine) {
        self.medicine = medicine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var medicineDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor().backgroundColor
        medicineDetailTableView.backgroundColor = CustomColor().backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(shoppingCartButtonPressed))
        
        medicineDetailTableView.register(UINib(nibName: MedicineDetailTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MedicineDetailTableViewCell.reuseIdentifier)
        medicineDetailTableView.dataSource = self
        medicineDetailTableView.delegate = self
    }
    
    @objc
    private func shoppingCartButtonPressed() {
        navigationController?.pushViewController(ShoppingCartViewController(), animated: true)
    }
    
}

extension MedicineDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = medicineDetailTableView.dequeueReusableCell(withIdentifier: MedicineDetailTableViewCell.reuseIdentifier, for: indexPath) as? MedicineDetailTableViewCell else {
            return UITableViewCell()
        }
        cell.createMedicineDetail(medicine: medicine)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

