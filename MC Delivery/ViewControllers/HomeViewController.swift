//
//  HomeViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    private let customButton = CustomButton()
    private var medicinesRequest = MedicinesRequest()
    private var medicineList = [Medicine]()
    private var total = 0
    private var page = 1
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicinesRequest.getAllMedicinesWithPagination(page: page) { medicines, total in
            
            self.medicineList.append(contentsOf: medicines)
//            print(self.medicineList.count)
            self.total = total
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
//            print(self.medicineList.count)
//            print(self.total)
        }
        
        DispatchQueue.main.async {
            self.view.backgroundColor = CustomColor().backgroundColor
            self.title = "MyanCare Pharmacy"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.standardAppearance = CustomNavigationBar().navBar
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.homeCollectionView.register(UINib(nibName: MedicineCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MedicineCollectionViewCell.reuseIdentifier)
            self.homeCollectionView.backgroundColor = CustomColor().backgroundColor
            self.homeCollectionView.delegate = self
            self.homeCollectionView.dataSource = self
            self.homeCollectionView.collectionViewLayout = CustomLayout.configureLayout()
            self.navigationItem.leftBarButtonItem = self.customButton.menuButton
        }
        customButton.menuButton.target = self
        customButton.menuButton.action = #selector(menuButtonPressed)
    }
    
    @objc
    private func menuButtonPressed() {
        let menu = SideMenuNavigationController(rootViewController: MenuViewController())
        menu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        present(menu, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let medicineDetailVC = MedicineDetailViewController(medicine: medicineList[indexPath.row])
        navigationController?.pushViewController(medicineDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medicineList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MedicineCollectionViewCell.reuseIdentifier, for: indexPath) as? MedicineCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.createMedicineCell(medicine: medicineList[indexPath.row])
        return cell
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if medicineList.count < total {
            page += 1
            medicinesRequest.getAllMedicinesWithPagination(page: page) { medicines,_ in
                self.medicineList.append(contentsOf: medicines)

                DispatchQueue.main.async {
                    self.homeCollectionView.reloadData()
                }
            }
        }
        
    }
}
