//
//  VideoCallViewController.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 2/25/23.
//

import UIKit
import TwilioVideo

class VideoCallViewController: UIViewController {
    
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?

    @IBOutlet weak var previewView: VideoView!
    
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var calleeNameLabel: UILabel!
    @IBOutlet weak var callStateLabel: UILabel!
    
    deinit {
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startPreview()
    }

    @IBAction func endButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

//            if (frontCamera != nil && backCamera != nil) {
//                // We will flip camera on tap.
//                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.flipCamera))
//                self.previewView.addGestureRecognizer(tap)
//            }

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
    
//    @objc func flipCamera() {
//        var newDevice: AVCaptureDevice?
//
//        if let camera = self.camera, let captureDevice = camera.device {
//            if captureDevice.position == .front {
//                newDevice = CameraSource.captureDevice(position: .back)
//            } else {
//                newDevice = CameraSource.captureDevice(position: .front)
//            }
//
//            if let newDevice = newDevice {
//                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
//                    if let error = error {
//                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
//                    } else {
//                        self.previewView.shouldMirror = (captureDevice.position == .front)
//                    }
//                }
//            }
//        }
//    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
}

extension VideoCallViewController: CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}
