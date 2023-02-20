//
//  CustomNavigationBar.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit

struct CustomNavigationBar {
    
    let navBar: UINavigationBarAppearance!

    init() {
        navBar = UINavigationBarAppearance()
        navBar.backgroundColor = CustomColor().backgroundColor
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
