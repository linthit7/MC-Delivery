//
//  CustomHeaderView.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit

struct CustomHeaderView {
    
    let headerView: UIView!
    
    init(tableView: UITableView, section: Int) {
        headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        switch section {
        case 0: label.text = "Shop by Category"
        case 1: label.text = "Popular Products"
        default: label.text = ""
        }
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .white
        headerView.addSubview(label)
    }
}
