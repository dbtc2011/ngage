//
//  RequestManager.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 29/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

enum Task {
    case register(Parameters)
    case validateRegistration(Parameters)
    case sendPinCode(Parameters)
    case resendVerificationCode(Parameters)
    case getMission(Parameters)
    case getTaskContent(Parameters)
    case insertRecord(Parameters)
    case uploadPicture(Parameters)
    case validateMission(Parameters)
    case getServerTime(Parameters)
    case getMaxMission(Parameters)
    case redeem(Parameters)
    case getHistory(Parameters)
    case getLoadList(Parameters)
    case getLoadCentral(Parameters)
    case getServices(Parameters)
    case merchantList(Parameters)
    case orderProcess(Parameters)
    case referralSMS(Parameters)
    case unlockMission(Parameters)
    case merchantInfo(Parameters)
    case refreshPoints(Parameters)
    case addReferral(Parameters)
    case checkMission(Parameters)
}

typealias SuccessBlock = (_ response: Any) -> Void
typealias FailureBlock = (_ error: NSError) -> Void
typealias CompletionBlock = (_ response: JSON?, _ error: NSError?) -> Void

class RequestManager {
    static let sharedInstance = SessionManager()
    class func perform(task: Task, completion: @escaping CompletionBlock) {
        self.invoke(task: task, completion: completion)
    }
    
    private class func invoke(task: Task, completion: @escaping CompletionBlock) {
        
        let reqTask: RequestTask = {
            
            switch task {
            case let .register(parameters):
                return RequestTask(urlRequest: Router.register(parameter: parameters))
                
            case let .validateRegistration(parameters):
                return RequestTask(urlRequest: Router.validateRegistration(parameter: parameters))
                
            case let .sendPinCode(parameters):
                return RequestTask(urlRequest: Router.sendPinCode(parameter: parameters))
                
            case let .resendVerificationCode(parameters):
                return RequestTask(urlRequest: Router.resendVerificationCode(parameter: parameters))
                
            case let .getMission(parameters):
                return RequestTask(urlRequest: Router.getMission(parameter: parameters))
                
            case let .getTaskContent(parameters):
                return RequestTask(urlRequest: Router.getTaskContent(parameter: parameters))
                
            case let .insertRecord(parameters):
                return RequestTask(urlRequest: Router.insertRecord(parameter: parameters))
                
            case let .uploadPicture(parameters):
                return RequestTask(urlRequest: Router.uploadPicture(parameter: parameters))
                
            case let .validateMission(parameters):
                return RequestTask(urlRequest: Router.validateMission(parameter: parameters))
                
            case let .getServerTime(parameters):
                return RequestTask(urlRequest: Router.getServerTime(parameter: parameters))
                
            case let .getMaxMission(parameters):
                return RequestTask(urlRequest: Router.getMaxMission(parameter: parameters))
                
            case let .redeem(parameters):
                return RequestTask(urlRequest: Router.redeem(parameter: parameters))
                
            case let .getHistory(parameters):
                return RequestTask(urlRequest: Router.getHistory(parameter: parameters))
                
            case let .getLoadList(parameters):
                return RequestTask(urlRequest: Router.getLoadList(parameter: parameters))
                
            case let .getLoadCentral(parameters):
                return RequestTask(urlRequest: Router.getLoadCentral(parameter: parameters))
                
            case let .getServices(parameters):
                return RequestTask(urlRequest: Router.getServices(parameter: parameters))
                
            case let .merchantList(parameters):
                return RequestTask(urlRequest: Router.merchantList(parameter: parameters))
                
            case let .orderProcess(parameters):
                return RequestTask(urlRequest: Router.orderProcess(parameter: parameters))
                
            case let .referralSMS(parameters):
                return RequestTask(urlRequest: Router.referralSMS(parameter: parameters))
                
            case let .unlockMission(parameters):
                return RequestTask(urlRequest: Router.unlockMission(parameter: parameters))
                
            case let .merchantInfo(parameters):
                return RequestTask(urlRequest: Router.merchantInfo(parameter: parameters))
                
            case let .refreshPoints(parameters):
                return RequestTask(urlRequest: Router.refreshPoints(parameter: parameters))
                
            case let .addReferral(parameters):
                return RequestTask(urlRequest: Router.addReferral(parameter: parameters))
                
            case let .checkMission(parameters):
                return RequestTask(urlRequest: Router.checkMission(parameter: parameters))
            }
            
        }()
        print("Task = \(task)")
        reqTask.perform({ (response) in
            let responseJSON = JSON(response)
            if let error = responseJSON["Message"].string {
                completion(nil, NSError(domain: "Ngage", code: 500, userInfo: [NSLocalizedDescriptionKey: error]))
            }else {
                completion(responseJSON, nil)
            }

        }) { (error) in
            // show error if needed
            completion(nil, error)
        }
    }
    
}
