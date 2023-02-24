//
//  CallHandler.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/24/23.
//

import CallKit


class CallManager: NSObject, CXProviderDelegate {
    
    //MARK: - Delegate

    func providerDidReset(_ provider: CXProvider) {}
    
    
    let provider = CXProvider(configuration: CXProviderConfiguration())
    let callController = CXCallController()
    
    override init() {
        super.init()
        
        provider.setDelegate(self, queue: nil)
    }
    
    func reportIncomingCall(id: UUID, handle: String) {
        
        let update = CXCallUpdate()
        update.hasVideo = true
        let handle = CXHandle(type: .generic, value: handle)
        update.remoteHandle = handle
        
        provider.reportNewIncomingCall(with: id, update: update) { error in
            if let error = error {
                print(error)
            } else {
                print("Call reported")
            }
        }
        
    }
    
    func startCall(id: UUID, handle: String) {
        
        let handle = CXHandle(type: .generic, value: handle)
        let action = CXStartCallAction(call: id, handle: handle)
        action.isVideo = true
        let transaction = CXTransaction(action: action)
        
        callController.request(transaction) { error in
            if let error = error {
                print(error)
            } else {
                print("Started call")
            }
        }
    }
    
}
