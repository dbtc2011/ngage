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

final class RegisterService: RequestManager {
    
    class func register(fbid: String, fName: String, lName: String, gender: String, email: String, referralCode: String, msisdn: String, operatorID: String, refferedBy: String, success: @escaping CompletionBlock) {
        let user = UserModel().mainUser()
        let long = ""
        let lat = ""
        let parameter = ["FBID" : fbid, "FName": fName, "LName": lName, "Gender": gender, "Email": email, "ReferralCode": referralCode, "DeviceID": user.deviceID, "Msisdn": msisdn, "Lat": lat, "LLong": long, "OperatorID": operatorID, "ReferredBy": refferedBy, "ltype" : "1"]
        perform(task: .register(parameter)) { (result, error) in
            print("Result = \(String(describing: result))")
            success(result, error)
        }
    }
    
    class func validateRegistration(fbid: String, pCode: String, mobileNumber: String, success: @escaping CompletionBlock) {
        
        let parameter = ["FBID": fbid, "Pcode": pCode, "MSISDN": mobileNumber]
        perform(task: .validateRegistration(parameter)) { (result, error) in
            print("Result = \(String(describing: result))")
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
    
    class func insertRecord(missionID: String, taskID: String, tasktype: String, FBID: String, ContentID: String, SubContentID: String, Answer: String, WatchType: String, WatchTime: String, DeviceID: String, TaskStatus: String, success: @escaping CompletionBlock) {
        let deviceID = ""
        let parameter = ["missionID": missionID, "taskID": taskID, "tasktype": tasktype, "FBID": FBID, "ContentID": ContentID, "SubContentID" : SubContentID, "Answer": Answer, "WatchType": WatchType, "WatchTime": WatchTime, "DeviceID": deviceID, "TaskStatus": TaskStatus]
        perform(task: .insertRecord(parameter)) { (result, error) in
            
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
        
        let parameter = ["To": to, "pcode": pcode, "FBID": pcode, "Prev_Points": prevPoints, "Current_Points" : currentPoint, "Points": points]
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
    
}

