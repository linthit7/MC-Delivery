//
//  HomeViewController+SideMenu.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/16/23.
//

import SideMenu

extension HomeViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        if navigationController?.visibleViewController == self {
            if AppDelegate.loginState {
                let accessToken = (CredentialsStore.getCredentials()?.accessToken)!
                OrderRequest(accessToken: accessToken).getOngoingOrder { ongoingOrder in
                    if ongoingOrder.count != 0 {
                        self.customizedSheet()
                    }
                }
            }
        }
    }
}
