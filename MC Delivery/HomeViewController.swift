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
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.view.backgroundColor = self.customColor.backgroundColor
            self.title = "MyanCare Pharmacy"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.standardAppearance = self.customNavBar.navBar
            self.homeTableView.backgroundColor = self.customColor.backgroundColor
            self.homeTableView.delegate = self
            self.homeTableView.dataSource = self
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {return 2}
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 80}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return CustomHeaderView(tableView: tableView, section: section).headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 150
        case 1: return 300
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return 1}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .gray
        return cell
    }
    
    
}
