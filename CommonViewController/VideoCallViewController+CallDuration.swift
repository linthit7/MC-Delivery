//
//  VideoCallViewController+CallDuration.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/16/23.
//

import Foundation

extension VideoCallViewController {
    
    func showCallDurationTimer() {
        DispatchQueue.main.async { [self] in
            secondLabel.isHidden = false
            firstColonLabel.isHidden = false
            minuteLabel.isHidden = false
        }
        startTimer()
    }
    
    func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimerForSecond), userInfo: nil, repeats: true)
    }
    
    @objc
    private func startTimerForSecond() {
        if second < 9 {
            second += 1
            DispatchQueue.main.async { [self] in
                secondLabel.text = "0\(second)"
            }
        } else if second < 59 {
            second += 1
            DispatchQueue.main.async { [self] in
                secondLabel.text = "\(second)"
            }
        } else { startTimerForMinute() }
    }
    
    private func startTimerForMinute() {
        if minute < 9 {
            second = 0
            minute += 1
            DispatchQueue.main.async { [self] in
                secondLabel.text = "\(second)"
                minuteLabel.text = "0\(minute)"
            }
        } else if minute < 59 {
            second = 0
            minute += 1
            DispatchQueue.main.async { [self] in
                secondLabel.text = "\(second)"
                minuteLabel.text = "\(minute)"
            }
        } else { startTimerForHour() }
    }
    
    private func startTimerForHour() {
        
        if secondColonLabel.isHidden, hourLabel.isHidden {
            secondColonLabel.isHidden = false
            hourLabel.isHidden = false
        }
        
        if hour < 9 {
            second = 0
            minute = 0
            hour += 1
            DispatchQueue.main.async { [self] in
                secondLabel.text = "\(second)"
                minuteLabel.text = "\(minute)"
                hourLabel.text = "0\(hour)"
            }
        } else {
            second = 0
            minute = 0
            hour += 1
            DispatchQueue.main.async { [self] in
                secondLabel.text = "\(second)"
                minuteLabel.text = "\(minute)"
                hourLabel.text = "\(hour)"
            }
        }
    }
}
