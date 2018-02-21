//
//  HomeCollectionViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
protocol HomeCollectionViewCellDelegate {
    func homeDidTapStart(tag: Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var viewButtonContainer: UIView!
    var delegate : HomeCollectionViewCellDelegate?
    
    func setupContents(mission : MissionModel) {
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
    }
    
    @IBAction func didTapStart(_ sender: UIButton) {
        delegate?.homeDidTapStart(tag: self.tag)
    }
    
    func updateTime() {
        var time = ""
        let newDate = Date()
        let difference = Double(newDate.timeIntervalSince(TimeManager.sharedInstance.currentDate))
        let serverCounter = Double(TimeManager.sharedInstance.midnightDate.timeIntervalSince(TimeManager.sharedInstance.serverDate))
        let timeRemaining = serverCounter - difference
        let timeInterval = TimeInterval(exactly: timeRemaining)
        time = timeInterval!.hoursMinutesSecondMS
        buttonWidth.constant = 200
        button.setTitle(time, for: UIControlState.normal)
    }
}


