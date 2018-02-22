//
//  HomeCollectionViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

enum MissionState : Int {
    
    case locked = 0, enabled = 1, soon = 2, expired = 3, completed = 4
}

protocol HomeCollectionViewCellDelegate {
    func homeDidTapStart(tag: Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var viewButtonContainer: UIView!
    private var state : MissionState!
    private var missionCode : Int = 0
    var delegate : HomeCollectionViewCellDelegate?
    
    func setupContents(mission : MissionModel) {
        missionCode = mission.code
        state = mission.state
        print("State value = \(mission.state)")
        self.buttonWidth.constant = 200
        state = setMissionState(mission: mission)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
        viewButtonContainer.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorSecondary)
        if mission.imageTask!.data != nil {
            if let imageData = UIImage(data: mission.imageTask!.data!) {
                image.image = imageData
                
            }
        }
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        switch state {
        case .locked:
            self.button.setTitle("LOCKED", for: UIControlState.normal)
            updateTime()
            
        case .expired:
            self.button.setTitle("EXPIRED", for: UIControlState.normal)
            button.isUserInteractionEnabled = false
            
        case .soon:
            self.button.setTitle("COMING SOON", for: UIControlState.normal)
            button.isUserInteractionEnabled = false
            
        case .completed:
            self.button.setTitle("COMPLETED", for: UIControlState.normal)
            button.isUserInteractionEnabled = true
            
        default:
            self.button.setTitle("START", for: UIControlState.normal)
            button.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func didTapStart(_ sender: UIButton) {
        delegate?.homeDidTapStart(tag: self.tag)
    }
   
    func updateTime() {
        // Dont proceed if mission code is 0 (First mission) or mission is expired or mission is not yet started
        if (!TimeManager.sharedInstance.hasStartedMission || missionCode == TimeManager.sharedInstance.startedMissionCode || missionCode == 1) {
            return
        }else if (state != MissionState.enabled && state != MissionState.locked) {
            return
        }
        button.isUserInteractionEnabled = false
        var time = ""
        let newDate = Date()
        let difference = Double(newDate.timeIntervalSince(TimeManager.sharedInstance.currentDate))
        let serverCounter = Double(TimeManager.sharedInstance.midnightDate.timeIntervalSince(TimeManager.sharedInstance.serverDate))
        let timeRemaining = serverCounter - difference
        if timeRemaining <= 0 {
            print("Should false \(timeRemaining)")
            TimeManager.sharedInstance.hasStartedMission = false
        }
        let timeInterval = TimeInterval(exactly: timeRemaining)
        time = timeInterval!.hoursMinutesSecondMS + " REMAINING"

        DispatchQueue.main.async {
            self.buttonWidth.constant = 200
            self.button.setTitle(time, for: UIControlState.normal)
            
        }
        
    }
    
    private func setMissionState(mission : MissionModel) -> MissionState{
        
//        if mission.code == 1 {
//            return MissionState.enabled
//        }
//        let serverDate = TimeManager.sharedInstance.serverDate
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        
//        //        formatter.locale = Locale(identifier: "en_US_POSIX")
//        if let startDate = formatter.date(from: "\(mission.startDate) +0000") {
//            let startCounter = Double(serverDate!.timeIntervalSince(startDate))
//            if startCounter < 0 {
//                return MissionState.soon
//            }
//            
//            print("Start time = \(startDate)")
//            
//        }
//        if let endDate = formatter.date(from: "\(mission.endDate) +0000") {
//            let endCounter = Double(serverDate!.timeIntervalSince(endDate))
//            if endCounter < 0 {
//                return MissionState.expired
//            }
//            print("End time = \(endDate)")
//        }
//        print("Server time = \(serverDate!)")
        
        if missionCode == 1 && TimeManager.sharedInstance.hasStartedMission {
            return MissionState.completed
        }
        
        if missionCode == TimeManager.sharedInstance.startedMissionCode && TimeManager.sharedInstance.hasStartedMission {
            return MissionState.enabled
        }
        if mission.code != 1 && !TimeManager.sharedInstance.hasFinishedFirstTask {
            return MissionState.locked
        }
        if TimeManager.sharedInstance.hasStartedMission && mission.code != TimeManager.sharedInstance.startedMissionCode {
            return MissionState.locked
        }
        return state
    }
}


