//
//  VideoCallViewController+Twilio.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/16/23.
//

import Foundation
import TwilioVideo

// MARK:- RoomDelegate & LocalParticipantDelegate
extension VideoCallViewController : RoomDelegate, LocalParticipantDelegate {
    
    func roomDidConnect(room: Room) {
        callManager.audioDevice.isEnabled = true
        
        if let localParticipant = room.localParticipant {
            localParticipant.delegate = self
        }
        
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
        
        if !room.remoteParticipants.isEmpty {
            calleeNameLabel.text = calleeName
            showCallDurationTimer()
        }
        
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        cleanupRemoteParticipant()
        self.room = nil
        showRoomUI(inRoom: false)
        navigationController?.popViewController(animated: false)
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        self.room = nil
        showRoomUI(inRoom: false)
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        DispatchQueue.main.async { [self] in
            calleeNameLabel.text = calleeName
            showCallDurationTimer()
        }
        participant.delegate = self
        callManager.provider.reportOutgoingCall(with: UUID(uuidString: (socketRoom?.roomName)!)!, connectedAt: Date())
    }
}

// MARK:- RemoteParticipantDelegate
extension VideoCallViewController : RemoteParticipantDelegate {
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        if (self.remoteParticipant == nil) { _ = renderRemoteParticipant(participant: participant) }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }    
}
