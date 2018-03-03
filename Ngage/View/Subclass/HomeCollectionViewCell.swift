//
//  HomeCollectionViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

enum MissionState : Int {
    
    case locked = 0, enabled = 1, soon = 2, expired = 3, completed = 4, started = 5
}

protocol HomeCollectionViewCellDelegate {
    func homeDidTapStart(tag: Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonLock: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var viewButtonContainer: UIView!
    private var state = MissionState.enabled
    private var missionCode : Int = 0
    @IBOutlet weak var lockContainerView: UIView!
    var delegate : HomeCollectionViewCellDelegate?
    
    func setupContents(mission : MissionModel) {
        missionCode = mission.code
        state = mission.state
        lockContainerView.isHidden = true
        buttonLock.isHidden = true
        self.buttonWidth.constant = 200
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
            button.isUserInteractionEnabled = false
            buttonLock.isHidden = false
            lockContainerView.isHidden = false
            buttonLock.setImage(UIImage(named: "ic_lock"), for: UIControlState.normal)
            updateTime()
            
        case .expired:
            self.button.setTitle("EXPIRED", for: UIControlState.normal)
            button.isUserInteractionEnabled = false
            lockContainerView.isHidden = false
            buttonLock.isHidden = false
            buttonLock.setImage(UIImage(named: "ic_expire"), for: UIControlState.normal)
            
        case .soon:
            self.button.setTitle("COMING SOON", for: UIControlState.normal)
            button.isUserInteractionEnabled = false
            
        case .completed:
            self.button.setTitle("COMPLETED", for: UIControlState.normal)
            button.isUserInteractionEnabled = true
            
        case .started:
            self.button.setTitle("CONTINUE", for: UIControlState.normal)
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
        if (!UserDefaults.standard.bool(forKey: Keys.keyHasStartedMission) || missionCode == UserDefaults.standard.value(forKey: Keys.keyMissionCode) as! Int || missionCode == 1) {
            return
        }else if (state == MissionState.completed) {
            return
        }
        
        button.isUserInteractionEnabled = false
        buttonLock.isHidden = false
        lockContainerView.isHidden = false
        buttonLock.setImage(UIImage(named: "ic_lock"), for: UIControlState.normal)
       
        var time = ""
        let newDate = Date()
        let difference = Double(newDate.timeIntervalSince(TimeManager.sharedInstance.currentDate))
        let serverCounter = Double(TimeManager.sharedInstance.midnightDate.timeIntervalSince(TimeManager.sharedInstance.serverDate))
        let timeRemaining = serverCounter - difference
        if timeRemaining <= 0 {
            UserDefaults.standard.set(false, forKey: Keys.keyHasStartedMission)
        }
        let timeInterval = TimeInterval(exactly: timeRemaining)
        time = timeInterval!.hoursMinutesSecondMS + " REMAINING"
        
        DispatchQueue.main.async {
            self.buttonWidth.constant = 200
            self.button.setTitle(time, for: UIControlState.normal)
            
        }
        
    }
}


