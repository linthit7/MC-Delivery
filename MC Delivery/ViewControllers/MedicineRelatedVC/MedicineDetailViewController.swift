//
//  MedicineDetailViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/22/23.
//

import UIKit

class MedicineDetailViewController: UIViewController {
    
    private let medicineId: String
    private var medicine: Medicine!
    
    init(medicineId: String) {
        self.medicineId = medicineId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var medicineDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationCenter()
        
        view.backgroundColor = CustomColor().backgroundColor
        medicineDetailTableView.backgroundColor = CustomColor().backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(shoppingCartButtonPressed))
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        MedicineRequest.getMedicineById(medicineId: medicineId) { [self] medicine in
            self.medicine = medicine
            DispatchQueue.main.async { [self] in
                medicineDetailTableView.register(UINib(nibName: MedicineDetailTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MedicineDetailTableViewCell.reuseIdentifier)
                medicineDetailTableView.dataSource = self
                medicineDetailTableView.delegate = self
                medicineDetailTableView.reloadData()
            }
        }
    }
    
    @objc
    private func shoppingCartButtonPressed() {
        navigationController?.pushViewController(ShoppingCartViewController(), animated: true)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(addToBasketButtonPressed), name: ShoppingCart.Alert.addedToPersistentStore.rawValue, object: nil)
    }
    
    @objc
    private func addToBasketButtonPressed() {
        navigationController?.popViewController(animated: true)
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

