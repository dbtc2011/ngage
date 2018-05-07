//
//  HomeCollectionViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

enum MissionState : Int {
    
    case locked = 0, enabled = 1, soon = 2, expired = 3, completed = 4, started = 5, disabled = 6
}

protocol HomeCollectionViewCellDelegate {
    func homeDidTapStart(tag: Int)
    func homeDidTapLock(tag:Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonLockWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonLockTop: NSLayoutConstraint!
    @IBOutlet weak var buttonLockHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonLock: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var viewButtonContainer: UIView!
    @IBOutlet weak var viewEnds: UIView!
    @IBOutlet weak var viewEndsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelEndsin: UILabel!
    @IBOutlet weak var labelRemainingPeriod: UILabel!
    @IBOutlet weak var viewContent: UIView!
    private var state = MissionState.enabled
    private var missionCode : Int = 0
    @IBOutlet weak var lockContainerView: UIView!
    var delegate : HomeCollectionViewCellDelegate?
    
    func setupContents(mission : MissionModel) {
        viewEnds.isHidden = false
        viewEndsHeightConstraint.constant = 60.0
        if mission.code == 1 || mission.state == .disabled {
            viewEnds.isHidden = true
            viewEndsHeightConstraint.constant = 0.0
        }
        viewContent.layer.cornerRadius = 15
        viewContent.layer.masksToBounds = true
        viewContent.clipsToBounds = true
        missionCode = mission.code
        buttonLock.tag = missionCode
        state = mission.state
        lockContainerView.isHidden = true
        buttonLock.isHidden = true
        self.buttonWidth.constant = 100
        button.layer.cornerRadius = 13
        labelEndsin.text = "Mission ends in"
        button.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
        viewButtonContainer.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorSecondary)
        if mission.imageTask!.data != nil {
            if let imageData = UIImage(data: mission.imageTask!.data!) {
                image.image = imageData
                
            }
        }
        // Double checking of state, server time might be nil 
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dateExpiry = formatter.date(from: mission.endDate) {
            if let expiryDifference = TimeManager.sharedInstance.serverDate.timeIntervalSince(dateExpiry) as? Double, expiryDifference > 0 {
                state = .expired
            }
        }
        switch state {
        case .locked:
            self.button.setTitle("LOCKED", for: UIControlState.normal)
            button.isUserInteractionEnabled = false
            buttonLock.isHidden = false
            lockContainerView.isHidden = false
            buttonLock.setImage(UIImage(named: "ic_lock"), for: UIControlState.normal)
            updateTime(mission: mission)
            
        case .expired:
            self.button.setTitle("EXPIRED", for: UIControlState.normal)
            button.isUserInteractionEnabled = false
            lockContainerView.isHidden = false
            buttonLock.isHidden = false
            self.buttonWidth.constant = 120
            labelEndsin.text = "Mission has expired"
            labelRemainingPeriod.text = "---"
            buttonLock.setImage(UIImage(named: "ic_expire"), for: UIControlState.normal)
            
        case .soon:
            self.button.setTitle("COMING SOON", for: UIControlState.normal)
            button.isUserInteractionEnabled = false
            self.buttonWidth.constant = 150
            
        case .completed:
            self.button.setTitle("COMPLETED", for: UIControlState.normal)
            button.isUserInteractionEnabled = true
            labelEndsin.text = "Mission Completed"
            labelRemainingPeriod.text = "---"
            self.buttonWidth.constant = 200
            
        case .started:
            self.button.setTitle("CONTINUE", for: UIControlState.normal)
            button.isUserInteractionEnabled = true
            
        case .disabled:
            lockContainerView.isHidden = false
            buttonLock.isHidden = false
            buttonLock.setImage(#imageLiteral(resourceName: "ic_unavailable"), for: UIControlState.normal)
            buttonLockWidth.constant = 160.0
            buttonLockHeight.constant = 160.0
            buttonLockTop.constant = -250.0
            
        default:
            self.button.setTitle("START", for: UIControlState.normal)
            button.isUserInteractionEnabled = true
        }
        
        buttonLock.contentMode = UIViewContentMode.scaleToFill
        self.clipsToBounds = true
        contentView.clipsToBounds = true
        super.layoutSubviews()
    }
    
    @IBAction func didTapLock(_ sender: UIButton) {
        delegate?.homeDidTapLock(tag: sender.tag)
    }
    @IBAction func didTapStart(_ sender: UIButton) {
        delegate?.homeDidTapStart(tag: self.tag)
    }
   
    func updateTime(mission: MissionModel) {
        if mission.state == .expired {
            labelEndsin.text = "Mission has expired"
            labelRemainingPeriod.text = "---"
            return
        } else if mission.state == .disabled {
            lockContainerView.isHidden = false
            buttonLock.isHidden = false
            buttonLock.setImage(#imageLiteral(resourceName: "ic_unavailable"), for: UIControlState.normal)
            buttonLockWidth.constant = 160.0
            buttonLockHeight.constant = 160.0
            buttonLockTop.constant = -250.0
            return
        }
    
        let user = UserModel().mainUser()
        // Dont proceed if mission code is 0 (First mission) or mission is expired or mission is not yet started
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var time = ""
        let newDate = Date()
        let difference = Double(newDate.timeIntervalSince(TimeManager.sharedInstance.currentDate))
        let serverCounter = Double(TimeManager.sharedInstance.midnightDate.timeIntervalSince(TimeManager.sharedInstance.serverDate))
        
        let timeRemaining = serverCounter - difference
        if timeRemaining <= 0 {
            CoreDataManager.sharedInstance.clearUserAvailableMissions { (result) in
                
            }
            UserDefaults.standard.set(true, forKey: Keys.shouldResetDisabled)
            UserDefaults.standard.set(false, forKey: Keys.keyHasStartedMission)
        }
        let timeInterval = TimeInterval(exactly: timeRemaining)
        
        time = timeInterval!.hoursMinutesSecondMS + " REMAINING"
        if let dateRemaining = formatter.date(from: "2018-05-31T00:00:00") {
            labelRemainingPeriod.text = timeInterval!.remainingDays(from: TimeManager.sharedInstance.serverDate, to: dateRemaining)
        }
        
        
        if (state == MissionState.completed) {
            labelEndsin.text = "Mission Completed"
            labelRemainingPeriod.text = "---"
            return
        }
        
        if (!UserDefaults.standard.bool(forKey: Keys.keyHasStartedMission) || user.availableMissions.contains(missionCode)  || missionCode == 1) {
            return
        }
        
        button.isUserInteractionEnabled = false
        buttonLock.isHidden = false
        lockContainerView.isHidden = false
        buttonLock.setImage(UIImage(named: "ic_lock"), for: UIControlState.normal)
        
        DispatchQueue.main.async {
            self.button.setTitle(time, for: UIControlState.normal)
            self.buttonWidth.constant = 200
        }
    }
}


