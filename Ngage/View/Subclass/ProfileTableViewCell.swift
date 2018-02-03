//
//  ProfileTableViewCell.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 31/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblReferralCode: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgProfile.layer.borderColor = UIColor.white.cgColor
        imgProfile.layer.borderWidth = 1.0
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Methods
    
    func setProfileInfo(withUserModel user: UserModel) {
        lblFullName.text = user.name.capitalized
        
        if let points = Int(user.points) {
            var textPoints = user.points
            if points > 0 {
                textPoints += "pts"
            } else {
                textPoints += "pt"
            }
            
            lblPoints.text = textPoints
        }
        
        lblReferralCode.text = "Referral Code: 12345678"
    }
}
