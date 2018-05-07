//
//  ProfileCollectionViewCell.swift
//  Ngage PH
//
//  Created by Mark Angeles on 27/03/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

protocol ProfileCollectionViewCellDelegate {
    
    func profileShouldGetPoints(withCell cell: ProfileCollectionViewCell)
    func profileDidSelect(link: String)
}

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewContent: UIView!
    private var dateFormatter = DateFormatter()
    
    
    @IBOutlet var redeemLeading: NSLayoutConstraint!
    @IBOutlet var buttonRedeem: UIButton!
    
    @IBOutlet var buttonAboutus: UIButton!
    @IBOutlet var buttonFAQS: UIButton!
    @IBOutlet var buttonTerms: UIButton!
    @IBOutlet var buttonPrivacy: UIButton!
    
    @IBOutlet weak var viewPoints: UIView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var missions: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameTop: NSLayoutConstraint!
    @IBOutlet weak var contentTop: NSLayoutConstraint!
    var delegate: ProfileCollectionViewCellDelegate?
    
    func setupUI(mission: Int) {
        let user = UserModel().mainUser()
        name.text = user.name
        email.text = user.emailAddress
        points.text = user.points
        missions.text = "\(mission)"
        date.text = ""
        if let data = user.image {
            image.image = UIImage(data: data)
            image.contentMode = UIViewContentMode.scaleAspectFill
        }else if let data = UserDefaults.standard.value(forKeyPath: "profile_image") as? Data {
            image.image = UIImage(data: data)
            image.contentMode = UIViewContentMode.scaleAspectFill
        }
        
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let dateOrigFormat = dateFormatter.date(from: user.dateCreated) {
            dateFormatter.dateFormat = "MMMM dd, YYYY"
            date.text = dateFormatter.string(from: dateOrigFormat)
        }else {
            date.text = fuckingManuallyParseTheDate()
        }
        date.text = fuckingManuallyParseTheDate()
    
        DispatchQueue.main.async {
            
            self.image.layer.cornerRadius = self.image.frame.size.width/2
            self.contentTop.constant = 0-(self.image.frame.size.width/2)
            self.nameTop.constant = (self.image.frame.size.width/2) + 10
            
            self.buttonAboutus.layer.cornerRadius = 10
            self.buttonFAQS.layer.cornerRadius = 10
            self.buttonTerms.layer.cornerRadius = 10
            self.buttonPrivacy.layer.cornerRadius = 10
            
            self.redeemLeading.constant = 0-(self.buttonRedeem.frame.size.width/2)
            
            self.points.layer.cornerRadius = self.points.bounds.size.width/2
            self.points.layer.borderColor = UIColor.white.cgColor
            self.points.layer.borderWidth = 5.0
            
            self.viewContent.layer.cornerRadius = 13.0
            self.viewPoints.layer.cornerRadius = 10.0
            self.missions.layer.cornerRadius = self.missions.frame.size.width/2
            self.missions.layer.borderColor = UIColor.white.cgColor
            self.missions.layer.borderWidth = 5.0
            self.layoutIfNeeded()
        }
        
        
    }
    
    func fuckingManuallyParseTheDate() -> String {
        let user = UserModel().mainUser()
        let dates = user.dateCreated.components(separatedBy: "T")
        if dates.count > 0 {
            var dateSince = dates[0]
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let dateOrigFormat = dateFormatter.date(from: dateSince) {
                dateFormatter.dateFormat = "MMMM dd, YYYY"
                dateSince = dateFormatter.string(from: dateOrigFormat)
                return dateSince
            }
        }
        return "nil"
    }
    
    func updatePoints(withPoints points: String) {
        self.points.text = points
    }
    
    @IBAction func aboutUsClicked(_ sender: UIButton) {
        delegate?.profileDidSelect(link: "about_us")
    }
    
    @IBAction func faqsButtonClicked(_ sender: UIButton) {
        delegate?.profileDidSelect(link: "faqs")
    }
    
    @IBAction func termsButtonClicked(_ sender: UIButton) {
        delegate?.profileDidSelect(link: "terms")
    }
    
    @IBAction func reloadButtonClicked(_ sender: UIButton) {
        delegate?.profileShouldGetPoints(withCell: self)
    }
    
    @IBAction func privacyButtonClicked(_ sender: UIButton) {
        delegate?.profileDidSelect(link: "privacy")
    }
}
