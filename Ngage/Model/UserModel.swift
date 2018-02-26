//
//  User.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 29/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

struct UserModel {
    var userId = ""
    var facebookId = ""
    
    var age = ""
    var emailAddress = ""
    var gender = ""
    var image: Data?
    var mobileNumber = ""
    var name = ""
    var points = "0"
    var birthday = ""
    var location = ""
    
    var missions = [MissionModel]()
    
    // App Generated or inputs
    var refferedBy = ""
    var referralCode = ""
    var operatorID = ""
    var deviceID = "23213123131"
}

extension UserModel {
    func mainUser() -> UserModel {
        if let user = CoreDataManager.sharedInstance.getMainUser() {
            var userModel = UserModel()
            userModel.name = user.name ?? ""
            userModel.emailAddress = user.emailAddress ?? ""
            userModel.mobileNumber = user.mobileNumber ?? ""
            userModel.facebookId = user.facebookId ?? ""
            userModel.userId = user.userId ?? ""
            userModel.age = user.age ?? ""
            userModel.gender = user.gender ?? ""
            userModel.points = user.points ?? ""
            userModel.referralCode = String(userModel.facebookId.characters.prefix(4) + userModel.mobileNumber.characters.suffix(4))
            UserDefaults.standard.set(userModel.referralCode, forKey: Keys.ReferralCode)
            return userModel
        }
        return UserModel()
    }
}
