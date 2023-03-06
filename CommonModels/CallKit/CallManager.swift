//
//  CallHandler.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/24/23.
//

import CallKit
import AVFAudio
import TwilioVideo

class CallManager: NSObject, CXProviderDelegate {
    
    static let sharedInstance = CallManager()
    var audioDevice = DefaultAudioDevice()

    func providerDidReset(_ provider: CXProvider) {}
    
    let provider = CXProvider(configuration: CXProviderConfiguration())
    let callController = CXCallController()
    let mSocket = SocketHandler.sharedInstance.getSocket()
    
    override init() {
        super.init()
        TwilioVideoSDK.audioDevice = self.audioDevice
        provider.setDelegate(self, queue: nil)
    }
    
    func reportIncomingCall(id: UUID, handle: String) {
        
        let update = CXCallUpdate()
        update.hasVideo = true
        let handle = CXHandle(type: .generic, value: handle)
        update.remoteHandle = handle
        
        provider.reportNewIncomingCall(with: id, update: update) { error in
            if let error = error {
                print(error, "incoming")
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
                print(error, "startCall")
            } else {
                print("Started calling UI")
            }
            action.fulfill(withDateStarted: Date())
        }
        print("PerformStartCallAction", id)
    }
    
    func performEndCallAction(id: UUID) {
        
        let action = CXEndCallAction(call: id)
        let transaction = CXTransaction(action: action)
        
        callController.request(transaction) { error in
            if let error = error {
                print(error, "endCall")
            } else {
                print("End call action", id)
            }
            action.fulfill(withDateEnded: Date())
        }
    }
    
    func performMuteCallAction(id: UUID) {
            
        let action = CXSetMutedCallAction(call: id, muted: true)
        
        let transaction = CXTransaction(action: action)
        
        callController.request(transaction) { error in
            if let error = error {
                print(error, "mute")
            } else {
                print("Set mute action", id)
                
            }
            action.fulfill()
        }
    }
    
    func performUnmuteCallAction(id: UUID) {
        
        let action = CXSetMutedCallAction(call: id, muted: false)
        let transaction = CXTransaction(action: action)
        
        callController.request(transaction) { error in
            if let error = error {
                print(error, "unmute")
            } else {
                print("Set umute action", id)
            }
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("Answer Call From Call Manager")
        action.fulfill(withDateConnected: Date())
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AnswerCall"), object: nil)
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("End Call From Call Manager")
        action.fulfill(withDateEnded: Date())
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EndCall"), object: nil)

    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        print("Muted Call From Call Manager")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Audio Session Enabled From Call Manager")
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Audio Session Disabled From Call Manager")
    }
   
}
