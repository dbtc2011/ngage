//
//  ProfileCollectionViewCell.swift
//  Ngage PH
//
//  Created by Mark Angeles on 27/03/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewPoints: UIView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var missions: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameTop: NSLayoutConstraint!
    @IBOutlet weak var contentTop: NSLayoutConstraint!
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
    
        DispatchQueue.main.async {
            
            self.image.layer.cornerRadius = self.image.frame.size.width/2
            self.contentTop.constant = 0-(self.image.frame.size.width/2)
            self.nameTop.constant = (self.image.frame.size.width/2) + 10
            
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
    
    @IBAction func aboutUsClicked(_ sender: UIButton) {
    }
    
    @IBAction func faqsButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func termsButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func privacyButtonClicked(_ sender: UIButton) {
    }
}
