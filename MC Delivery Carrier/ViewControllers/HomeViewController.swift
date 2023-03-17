//
//  HomeViewController.swift
//  MC Delivery Carrier
//
//  Created by Lin Thit Khant on 2/20/23.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    var ongoingOrderList = [OrderHistory]()
    var mSocket = SocketHandler.sharedInstance.getSocket()
    let callManager = CallManager.sharedInstance
    var room = MCRoom()
    
    private let customButton = CustomButton()
    
    @IBOutlet weak var ongoingOrderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppDelegate.loginState {
            if let token = CredentialsStore.getCredentials()?.accessToken {
                OrderRequest().getOngoingOrderRouteCarrier(accessToken: token) { [self] ongoingOrder in
                    ongoingOrderList.append(contentsOf: ongoingOrder)
                    DispatchQueue.main.async {
                        self.ongoingOrderTableView.reloadData()
                    }
                }
            }
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(startCall), name: NSNotification.Name("Call Delivery Person"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectVideoCall), name: NSNotification.Name(rawValue: "AnswerCall"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(declineCall), name: NSNotification.Name(rawValue: "EndCall"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeToastForLoginSuccess), name: NSNotification.Name("Login Successful"), object: nil)
        
        DispatchQueue.main.async { [self] in
            view.backgroundColor = CustomColor().backgroundColor
            title = "MyanCare Carrier"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.standardAppearance = CustomNavigationBar().navBar
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationItem.leftBarButtonItem = customButton.menuButton
            ongoingOrderTableView.backgroundColor = CustomColor().backgroundColor
            ongoingOrderTableView.register(UINib(nibName: OrderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
            ongoingOrderTableView.delegate = self
            ongoingOrderTableView.dataSource = self
        }
        customButton.menuButton.target = self
        customButton.menuButton.action = #selector(menuButtonPressed)
        
        mSocket.on("calling") { data, ack in
                        
            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String
            let token = dataDic?.value(forKey: "token") as? String
            let caller = dataDic?.value(forKey: "caller") as? NSDictionary
            let roomSid = dataDic?.value(forKey: "roomSid") as? String
            
            self.room.roomName = roomName
            self.room.token = token
            self.room.roomSid = roomSid
            
            self.callManager.reportIncomingCall(id: UUID(uuidString: roomName!)!, handle: caller?.value(forKey: "name") as! String)
        }
        mSocket.on("acceptCall") { data, ack in

            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String

            self.callManager.provider.reportOutgoingCall(with: UUID(uuidString: roomName!)!, connectedAt: Date())
        }
        mSocket.on("callEnded") { data, ack in
            
            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String
            
            self.callManager.performEndCallAction(id: UUID(uuidString: roomName!)!)
        }
        
        mSocket.on("missedCall") { data, ack in
            
            let dataDic = data[0] as? NSDictionary
            let roomName = dataDic?.value(forKey: "roomName") as? String
            
            self.callManager.performEndCallAction(id: UUID(uuidString: roomName!)!)
            self.view.makeToast("Missed Call", position: .top)
        }
    }
    
    @objc
    private func makeToastForLoginSuccess() {
        DispatchQueue.main.async {
            self.view.makeToast("Login Successful", position: .top)
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
        let orderHistory = CalleeStore.getOrderHistory()

        let data = [
            "callerId": orderHistory?.user,
            "calleeId": caller?._id,
            "roomName": room.roomName,
            "roomSid": room.roomSid
        ]
        
        mSocket.emit("acceptCall", data) {}
        
        let videoVC = VideoCallViewController(socketRoom: room, calleeName: (orderHistory?.userDetail[0].name)!)
        videoVC.callState = "Joining Call"
        navigationController?.pushViewController(videoVC, animated: false)
    }
    
    @objc
    private func declineCall() {
        
        let caller = CredentialsStore.getCredentials()?.user
        let orderHistory = CalleeStore.getOrderHistory()
        let room = RoomStore.getRoom()

        let data = [
            "callerId": orderHistory?.user,
            "calleeId": caller?._id,
            "roomName": room?.roomName,
            "roomSid": room?.roomSid
        ]
        
        mSocket.emit("declineCall", data) {}
    }
    @objc
    private func startCall() {
        let caller = CredentialsStore.getCredentials()?.user
        let orderHistory = CalleeStore.getOrderHistory()
        let room = RoomStore.getRoom()
        
        let data = [
            "callerId": caller?.id,
            "calleeId": orderHistory?.user,
            "roomName": room?.roomName,
            "roomSide": room?.roomSid
        ]
        
        self.mSocket.emit("startCall", data) {
            
            self.callManager.performStartCallAction(id: UUID(uuidString: (room?.roomName)!)!, handle: (orderHistory?.userDetail[0].name)!)

            let videoVC = VideoCallViewController(socketRoom: room!, calleeName: (orderHistory?.userDetail[0].name)!)
            videoVC.callState = "Calling"
            self.navigationController?.pushViewController(videoVC, animated: false)
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ongoingOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else { return UITableViewCell() }
        cell.createOrderHistoryCell(orderHistory: ongoingOrderList[indexPath.row], user: "Carrier")
        return cell
    }
    
    
}
