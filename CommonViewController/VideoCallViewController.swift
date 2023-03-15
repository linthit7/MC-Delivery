//
//  VideoCallViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/25/23.
//

import UIKit
import TwilioVideo
import CallKit

class VideoCallViewController: UIViewController, LocalParticipantDelegate {

    var room: Room?
    var socketRoom: MCRoom?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var localParticipant: LocalParticipant?
    
    let callManager = CallManager.sharedInstance
    let mSocket = SocketHandler.sharedInstance.getSocket()
    
    var calleeName = String()
    var callState = String()
    
    @IBOutlet weak var previewView: VideoView!
    @IBOutlet weak var remoteView: VideoView!
    
    @IBOutlet weak var calleeNameLabel: UILabel!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var endButoon: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    init(socketRoom: MCRoom, calleeName: String) {
        self.socketRoom = socketRoom
        self.calleeName = calleeName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder Error")
    }
    
    deinit {
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(callKitEndCallAction), name: NSNotification.Name(rawValue: "EndCall"), object: nil)
        
        mSocket.on("declineCall") { data, ack in
            print("Decline call received.")
            self.callManager.performEndCallAction(id: UUID(uuidString: (self.socketRoom?.roomName)!)!)
            self.room?.disconnect()
        }
        mSocket.on("callEnded") { data, ack in
            self.callManager.performEndCallAction(id: UUID(uuidString: (self.socketRoom?.roomName)!)!)
            self.room?.disconnect()
        }
        
        DispatchQueue.main.async { [self] in
            startPreview()
            connectToRoom()
        }
        
    }
    
    func setupUI() {
        DispatchQueue.main.async { [self] in
            remoteView.contentMode = .scaleAspectFill
            micButton.setTitle("", for: .normal)
            endButoon.setTitle("", for: .normal)
            cameraButton.setTitle("", for: .normal)
            calleeNameLabel.text = callState
        }
    }
    
    @objc
    private func callKitEndCallAction() { room?.disconnect() }
    
    @IBAction func endButtonPressed(_ sender: UIButton) {
        callManager.performEndCallAction(id: UUID(uuidString: (socketRoom?.roomName)!)!)
        room?.disconnect()
        
        let callerId = CredentialsStore.getCredentials()?.user
        let calleeId = CalleeStore.getCallee()
        
        let data = [
            "callerId": callerId?._id,
            "calleeId": calleeId?._id,
            "roomName": socketRoom?.roomName,
            "roomSid": socketRoom?.roomSid
        ]
        mSocket.emit("callEnded", data) {
            print("End Call Emitted")
        }
    }
    
    @IBAction func micButtonPresses(_ sender: UIButton) {
        
        let id = UUID(uuidString: (socketRoom?.roomName!)!)
        if micButton.imageView?.image == UIImage(systemName: "mic.fill") {
            micButton.setImage(UIImage(systemName: "mic.slash.fill"), for: .normal)
            callManager.performMuteCallAction(id: id!)
        } else {
            micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            callManager.performUnmuteCallAction(id: id!)
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        cameraOnOff()
    }
    
    @IBAction func camereFlipButtonPressed(_ sender: UIButton) {
        flipCamera()
    }
    
    private func cameraOnOff() {
        if cameraButton.imageView?.image == UIImage(systemName: "video.fill") {
            cameraButton.setImage(UIImage(systemName: "video.slash.fill"), for: .normal)
            localVideoTrack?.isEnabled = false
        } else {
            cameraButton.setImage(UIImage(systemName: "video.fill"), for: .normal)
            localVideoTrack?.isEnabled = true
        }
    }
    
    private func flipCamera() {
        var newDevice: AVCaptureDevice?

        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }

            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    
    private func connectToRoom() {
        prepareLocalMedia()
        
        let connectOptions = ConnectOptions(token: (socketRoom?.token)!) { (builder) in
            
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            let preferredVideoCodec = Settings.shared.videoCodec
            
            if preferredVideoCodec == .auto {
                builder.videoEncodingMode = .auto
            } else if let codec = preferredVideoCodec.codec {
                builder.preferredVideoCodecs = [codec]
            }
            
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            
            builder.roomName = self.socketRoom?.roomName
            builder.uuid = UUID(uuidString: (self.socketRoom?.roomName)!)
        }
        
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        showRoomUI(inRoom: true)
    }
    
    func showRoomUI(inRoom: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = inRoom
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    func prepareLocalMedia() {
        
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")
        }
        
        if (localVideoTrack == nil) {
            startPreview()
        }
    }
    
    func startPreview() {
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            
            let options = CameraSourceOptions {_ in }
            
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(options: options, delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.previewView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.logMessage(messageText:"No front or back capture device found!")
        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
               publication.isTrackSubscribed {
                subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }
    
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
               renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    
    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
}

// MARK:- RoomDelegate
extension VideoCallViewController : RoomDelegate {
    
    func roomDidConnect(room: Room) {
       
        callManager.audioDevice.isEnabled = true
        
        if let localParticipant = room.localParticipant {
            localParticipant.delegate = self
        }
        
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
        
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        self.showRoomUI(inRoom: false)
        navigationController?.popViewController(animated: false)
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        DispatchQueue.main.async { [self] in
            calleeNameLabel.text = calleeName
        }
        participant.delegate = self
        
        callManager.provider.reportOutgoingCall(with: UUID(uuidString: (socketRoom?.roomName)!)!, connectedAt: Date())
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {}
}

// MARK:- RemoteParticipantDelegate
extension VideoCallViewController : RemoteParticipantDelegate {
    
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.
        
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        
        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}


extension VideoCallViewController: CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}
