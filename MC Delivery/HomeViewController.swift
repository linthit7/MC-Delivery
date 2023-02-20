//
//  HomeViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let customColor = CustomColor()
    private let customButton = CustomButton()
    private let customNavBar = CustomNavigationBar()
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.view.backgroundColor = self.customColor.backgroundColor
            self.title = "MyanCare Pharmacy"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.standardAppearance = self.customNavBar.navBar
            self.homeCollectionView.register(UINib(nibName: MedicineCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MedicineCollectionViewCell.reuseIdentifier)
            self.homeCollectionView.backgroundColor = self.customColor.backgroundColor
            self.homeCollectionView.delegate = self
            self.homeCollectionView.dataSource = self
            self.homeCollectionView.collectionViewLayout = CustomLayout.configureLayout()
            self.navigationItem.leftBarButtonItem = self.customButton.menuButton
        }
        customButton.menuButton.target = self
        customButton.menuButton.action = #selector(menuButtonPressed)
    }
    
    @objc
    func menuButtonPressed() {
        print("Menu Button Pressed")
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MedicineCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    
}
