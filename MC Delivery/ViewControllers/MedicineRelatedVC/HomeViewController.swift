//
//  HomeViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit
import SideMenu
//import BadgeHub

class HomeViewController: UIViewController {
    
    private let customButton = CustomButton()
    private var medicinesRequest = MedicinesRequest()
    private var medicineList = [Medicine]()
    private var total = 0
    private var page = 1
    var mSocket = SocketHandler.sharedInstance.getSocket()
    let callManager = CallManager.sharedInstance
    var room = MCRoom()
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var onGoingUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNotificationCenter()
        medicinesRequest.getAllMedicinesWithPagination(page: page) { medicines, total in
            
            self.medicineList.append(contentsOf: medicines)
            self.total = total
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
        }
        
        DispatchQueue.main.async { [self] in
            view.backgroundColor = CustomColor().backgroundColor
            title = "MyanCare Pharmacy"
            navigationController?.navigationBar.standardAppearance = CustomNavigationBar().navBar
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.navigationBar.tintColor = UIColor.white
            homeCollectionView.register(UINib(nibName: MedicineCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MedicineCollectionViewCell.reuseIdentifier)
            homeCollectionView.backgroundColor = CustomColor().backgroundColor
            homeCollectionView.delegate = self
            homeCollectionView.dataSource = self
            homeCollectionView.collectionViewLayout = CustomLayout.configureLayout()
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(self.shoppingCartButtonPressed))
            navigationItem.leftBarButtonItem = customButton.menuButton
        }
        customButton.menuButton.target = self
        customButton.menuButton.action = #selector(menuButtonPressed)
        
        mSocket.on("calling") { data, ack in
            
            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String
            let token = dataDic?.value(forKey: "token") as? String
            let roomSid = dataDic?.value(forKey: "roomSid") as? String
            let caller = dataDic?.value(forKey: "caller") as? NSDictionary
            
            self.room.roomName = roomName
            self.room.token = token
            self.room.roomSid = roomSid
            
            self.callManager.reportIncomingCall(id: UUID(uuidString: roomName!)!, handle: caller?.value(forKey: "name") as! String)
        }
        
        mSocket.on("acceptCall") { data, ack in

            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String
            
            self.callManager.provider.reportOutgoingCall(with: UUID(uuidString: roomName!)!, connectedAt: Date())
            print("Accept Call Recieved From Home View Controller MCD")
        }
        
        mSocket.on("missedCall") {_,_ in
            print("Missed Call")
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
            "roomName": room.roomName,
            "roomSid": room.roomSid
            ]
        
        mSocket.emit("acceptCall", data) {
        }
        
        let videoVC = VideoCallViewController(socketRoom: room)
        navigationController?.pushViewController(videoVC, animated: true)
    }
    
    @objc
    private func declineCall() {
        
        let caller = CredentialsStore.getCredentials()?.user
        let callee = CalleeStore.getCallee()
        
        let data = [
            "callerId": callee?._id,
            "calleeId": caller?._id,
            "roomName": room.roomName,
            "roomSid": room.roomSid
        ]
        
        mSocket.emit("declineCall", data) {
            print("Emit decline Call From HomeVC")
        }
    }
    
    @objc
    private func shoppingCartButtonPressed() {
        navigationController?.pushViewController(ShoppingCartViewController(), animated: true)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectVideoCall), name: NSNotification.Name(rawValue: "AnswerCall"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(declineCall), name: NSNotification.Name(rawValue: "EndCall"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(orderPlaced), name: ShoppingCartLogic.Alert.orderSuccessAndCleanUpDone.rawValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orderCanceled), name: OrderRequest.Alert.orderCancelSuccess.rawValue, object: nil)
    }
    
    @objc
    private func orderPlaced() {
        DispatchQueue.main.async {
            self.view.makeToast("Order successful", position: .top)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @objc
    private func orderCanceled() {
        DispatchQueue.main.async {
            self.view.makeToast("Order canceled", position: .top)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let medicineDetailVC = MedicineDetailViewController(medicineId: medicineList[indexPath.row]._id)
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
