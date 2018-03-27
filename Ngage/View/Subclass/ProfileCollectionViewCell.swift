//
//  ProfileCollectionViewCell.swift
//  Ngage PH
//
//  Created by Mark Angeles on 27/03/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var membership: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var missions: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func setupUI(mission: Int) {
        let user = UserModel().mainUser()
        name.text = user.name
        email.text = user.emailAddress
        points.text = user.points
        missions.text = "\(mission)"
        membership.text = ""
        if let data = user.image {
            image.image = UIImage(data: data)
            image.contentMode = UIViewContentMode.scaleAspectFill
        }else if let data = UserDefaults.standard.value(forKeyPath: "profile_image") as? Data {
            image.image = UIImage(data: data)
            image.contentMode = UIViewContentMode.scaleAspectFill
        }
        
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        image.clipsToBounds = true
    }
    
    
    
}
