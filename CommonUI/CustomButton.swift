//
//  CustomUI.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit

struct CustomButton {
    
    let menuButton: UIBarButtonItem!
    
    init() {
        menuButton = UIBarButtonItem()
        menuButton.image = UIImage(systemName: "line.horizontal.3")
        menuButton.style = .plain
        menuButton.tintColor = .white
    }
}

