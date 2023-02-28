//
//  CallHandler.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/24/23.
//

import CallKit
import AVFAudio

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
                print("Report incoming call", id)
            }
        }
    }
    
    func performStartCallAction(id: UUID, handle: String) {
        
        let handle = CXHandle(type: .generic, value: handle)
        let action = CXStartCallAction(call: id, handle: handle)
        action.isVideo = true
        let transaction = CXTransaction(action: action)
        
        callController.request(transaction) { error in
            if let error = error {
                print(error)
            } else {
                print("Started calling UI")
            }
            action.fulfill(withDateStarted: Date())
        }
    }
    
    func performAnswerCallAction(id: UUID) {
        
        let action = CXAnswerCallAction(call: id)
        let transaction = CXTransaction(action: action)
        
        callController.request(transaction) { error in
            if let error = error {
                print(error)
            } else {
                print("Answer call action", id)
            }
            action.fulfill(withDateConnected: Date())
        }
    }
    
    func performEndCallAction(id: UUID) {
        
        let action = CXEndCallAction(call: id)
        let transaction = CXTransaction(action: action)
        
        callController.request(transaction) { error in
            if let error = error {
                print(error)
            } else {
                print("End call action", id)
            }
            action.fulfill(withDateEnded: Date())
        }
    }
    
    
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        
        print("Answer Call", action)
        action.fulfill(withDateConnected: Date())
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AnswerCall"), object: nil)
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("End Call", action)
        action.fulfill(withDateEnded: Date())
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EndCall"), object: nil)

    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        print("Muted Call", action)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Audio Session Enabled", audioSession)
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Audio Session Disabled", audioSession)
    }
   
}
