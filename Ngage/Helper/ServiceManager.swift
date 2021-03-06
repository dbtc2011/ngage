//
//  ServiceManager.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 29/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Firebase

final class RegisterService: RequestManager {
    
    class func register(fbid: String, fName: String, lName: String, gender: String, email: String, referralCode: String, msisdn: String, operatorID: String, refferedBy: String, success: @escaping CompletionBlock) {
        var user = UserModel().mainUser()
        if let token = UserDefaults.standard.string(forKey: Keys.DeviceID) {
            user.deviceID = token
        }else {
            user.deviceID = Messaging.messaging().fcmToken ?? ""
        }
        
        let long = ""
        let lat = ""
        let parameter = ["FBID" : fbid, "FName": fName, "LName": lName, "Gender": gender, "Email": email, "ReferralCode": referralCode, "DeviceID": user.deviceID, "Msisdn": msisdn, "Lat": lat, "LLong": long, "OperatorID": operatorID, "ReferredBy": refferedBy, "Itype" : "3"]
        perform(task: .register(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func unlockMission(fbid: String, mission: String, success: @escaping CompletionBlock) {
        
        let parameter = ["FBID": fbid, "MissionID": "\(mission)"]
        perform(task: .unlockMission(parameter)) { (result, error) in
            success(result, error)
        }
        
    }
    class func validateRegistration(fbid: String, pCode: String, mobileNumber: String, success: @escaping CompletionBlock) {
        
        let parameter = ["FBID": fbid, "Pcode": pCode, "MSISDN": mobileNumber]
        perform(task: .validateRegistration(parameter)) { (result, error) in
            success(result, error)
        }
        
    }
    
    class func generatePinCodeFor(msisdn: String, success: @escaping CompletionBlock) {
        
        let parameter = ["msisdn": msisdn]
        perform(task: .sendPinCode(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func resendVerificationCode(fbid: String, success: @escaping CompletionBlock) {
    
        let parameter = ["{FBID}" : fbid]
        perform(task: .resendVerificationCode(parameter)) { (result, error) in
            success(result, error)
        }
        
    }
    
    class func getMissionList(fbid: String, success: @escaping CompletionBlock) {
        
        let parameter = ["FBID": fbid]
        perform(task: .getMission(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func insertRecord(missionID: String, taskID: String, tasktype: String, FBID: String, ContentID: String, SubContentID: String, Answer: String, CorrectAnswer: String, WatchType: String, WatchTime: String, DeviceID: String, TaskStatus: String, Current_Points: String, Points: String, Prev_Points: String, success: @escaping CompletionBlock) {
        let user = UserModel().mainUser()
        let parameter = ["missionID": missionID, "taskID": taskID, "tasktype": tasktype, "FBID": FBID, "ContentID": ContentID, "SubContentID" : SubContentID, "Answer": Answer, "CorrectAnswer": CorrectAnswer, "WatchType": WatchType, "WatchTime": WatchTime, "DeviceID": user.deviceID, "TaskStatus": TaskStatus]
        perform(task: .insertRecord(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func getMerchantList(category: String, success: @escaping CompletionBlock) {
        
        let parameter = ["category" : category]
        perform(task: .merchantList(parameter)) { (result, error) in
            
            success(result, error)
            
        }
    }
    
    class func getLoadList(telco: String, success: @escaping CompletionBlock) {
        
        let parameter = ["{Telco}": telco]
        perform(task: .getLoadList(parameter)) { (result, error) in

            success(result, error)
        }
        
    }
    
    class func getServicesType(serviceType: String, success: @escaping CompletionBlock) {
        let parameter = ["{ServicesType}": serviceType]
        perform(task: .getServices(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func sendLoadCentral(to: String, pcode: String, fbid: String, prevPoints: String, currentPoint: String, points: String, success: @escaping CompletionBlock) {
        
        let parameter = ["To": to, "pcode": pcode, "FBID": fbid, "Prev_Points": prevPoints, "Current_Points" : currentPoint, "Points": points]
        perform(task: .getLoadCentral(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func getTaskContent(missionID: String, taskID: String, tasktype: String, contentID: String, FBID: String, success: @escaping CompletionBlock) {
        
        let parameter = ["missionID": missionID, "taskID": taskID, "tasktype": tasktype, "contentID": contentID, "FBID": FBID]
        perform(task: .getTaskContent(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func getHistory(fbid: String, success: @escaping CompletionBlock) {
        let parameter = ["{FBID}": fbid]
        perform(task: .getHistory(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func getMerchantInfo(merchantID: String, success: @escaping CompletionBlock) {
        let parameter = ["merchantid": merchantID]
        perform(task: .merchantInfo(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func getServerTime(success: @escaping CompletionBlock) {
        perform(task: .getServerTime([:])) { (result, error) in
            success(result, error)
        }
    }
    
    class func orderProcess(merchant: MerchantRedeemableModel, redeemDetails: RedeemMerchantForm, success: @escaping CompletionBlock) {
        let user = UserModel().mainUser()
        var previousPoints = 0
        var itemPoints = 0
        if let points = Int(user.points) {
            previousPoints = points
        }
        if let points = Int(redeemDetails.points) {
            itemPoints = points
        }
        let currentPoints = previousPoints - itemPoints
        
        let parameters = ["merchantid": merchant.id, "sendername": user.name, "sendermobile": user.mobileNumber, "senderemail": user.emailAddress, "recipientname": redeemDetails.fullName, "recipientmobile": redeemDetails.mobileNumber, "recipientemail": redeemDetails.emailAddress, "FBID": user.facebookId, "Prev_Points": previousPoints, "Current_Points": currentPoints, "Points": previousPoints, "MerchantName": merchant.name] as [String : Any]
        perform(task: .orderProcess(parameters)) { (result, error) in
            success(result, error)
        }
    }
    
    class func redeemPoints(FBID: String, MissionID: String, TaskID: String, Prev_Pointegers: String, Current_Pointegers: String, Pointegers: String, success: @escaping CompletionBlock) {
        
        let parameters = ["FBID": FBID, "MissionID": MissionID, "TaskID": TaskID, "Prev_Points": Prev_Pointegers, "Current_Points": Current_Pointegers, "Points": Pointegers]
        perform(task: .redeem(parameters)) { (result, error) in
            success(result, error)
        }
    }
    
    class func refreshPoints(fbid: String, success: @escaping CompletionBlock) {
        let parameter = ["{FBID}": fbid]
        perform(task: .refreshPoints(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func addReferral(FBID: String, ReferralCode: String, ReferredBy: String, success: @escaping CompletionBlock) {
        let parameter = ["FBID": FBID, "ReferralCode": ReferralCode, "ReferredBy":ReferredBy]
        perform(task: .addReferral(parameter)) { (result, error) in
            success(result, error)
        }
    }
    
    class func checkMissionAvailability(FBID: String, MissionID: Int, success: @escaping CompletionBlock) {
        let parameter = ["FBID": FBID, "MissionID": MissionID] as [String : Any]
        perform(task: .checkMission(parameter)) { (result, error) in
            print("Task result = \(result)")
            success(result, error)
        }
    }

}

