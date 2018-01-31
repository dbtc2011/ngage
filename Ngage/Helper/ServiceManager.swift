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
        
        let deviceId = ""
        let long = ""
        let lat = ""
        let parameter = ["FBID" : fbid, "FName": fName, "LName": lName, "Gender": gender, "Email": email, "ReferralCode": referralCode, "DeviceID": deviceId, "Msisdn": msisdn, "Lat": lat, "LLong": long, "OperatorID": operatorID, "ReferredBy": refferedBy]
        perform(task: .register(parameter)) { (result, error) in
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
    
    class func getMissionList(fbid: String, success: @escaping CompletionBlock) {
        
        let parameter = ["FBID": fbid]
        perform(task: .getMission(parameter)) { (result, error) in
            
        }
    }
    
    class func getTaskContent(missionID: String, taskID: String, tasktype: String, contentID: String, FBID: String) {
        
        let parameter = ["missionID" : missionID, "taskID": taskID, "tasktype": tasktype, "contentID": contentID, "FBID": FBID]
        perform(task: .getTaskContent(parameter)) { (result, error) in
            
        }
    }
    
    class func insertRecord(missionID: String, taskID: String, tasktype: String, FBID: String, ContentID: String, SubContentID: String, Answer: String, WatchType: String, WatchTime: String, DeviceID: String, TaskStatus: String, success: @escaping CompletionBlock) {
        let deviceID = ""
        let parameter = ["missionID": missionID, "taskID": taskID, "tasktype": tasktype, "FBID": FBID, "ContentID": ContentID, "SubContentID" : SubContentID, "Answer": Answer, "WatchType": WatchType, "WatchTime": WatchTime, "DeviceID": deviceID, "TaskStatus": TaskStatus]
        perform(task: .insertRecord(parameter)) { (result, error) in
            
        }
    }
    
    
    
}

