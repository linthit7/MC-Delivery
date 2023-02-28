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
    var mSocket = SocketHandler.sharedInstance.getSocket()
    var callManager = CallManager()
    var room = MCRoom()
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectVideoCall), name: NSNotification.Name(rawValue: "AnswerCall"), object: nil)
        
        medicinesRequest.getAllMedicinesWithPagination(page: page) { medicines, total in
            
            self.medicineList.append(contentsOf: medicines)
            self.total = total
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
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
        
        mSocket.on("calling") { data, ack in
            
            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String
            let token = dataDic?.value(forKey: "token") as? String
            let caller = dataDic?.value(forKey: "caller") as? NSDictionary
            
            self.room.roomName = roomName
            self.room.token = token
            
            self.callManager.reportIncomingCall(id: UUID(uuidString: roomName!)!, handle: caller?.value(forKey: "name") as! String)
        }
        
        mSocket.on("acceptCall") { data, ack in

            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String

//            self.callManager.performAnswerCallAction(id: UUID(uuidString: roomName!)!)
        }
    }
    
    @objc
    private func menuButtonPressed() {
        let menu = SideMenuNavigationController(rootViewController: MenuViewController())
        menu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        present(menu, animated: true, completion: nil)
    }
    
    @objc
    private func connectVideoCall() {
        
        let caller = CredentialsStore.getCredentials()?.user
        let callee =
            CalleeStore.getCallee()
        
        let data = [
            "callerId": callee?._id,
            "calleeId": caller?._id,
            "roomName": room.roomName
            ]
        
        mSocket.emit("acceptCall", data) {
        }
        
        let videoVC = VideoCallViewController(socketRoom: room)
        navigationController?.pushViewController(videoVC, animated: true)
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
