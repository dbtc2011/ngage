//
//  APIManager.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 29/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation

enum Endpoint : String {
    case register = "/svc/api/Registration"
    case sendPinCode = "/svc/api/SendPincode"
    case getMission = "/svc/api/GetMission"
    case getTaskContent = "/svc/api/GETContent"
    case insertRecord = "/svc/api/INSERTRecord"
    case uploadPicture = "/svc/api/Upload"
    case validateMission = "/svc/api/MaxUser/{MissionID}"
    case getServerTime = "/api/ServerTime"
    case getMaxMission = "/api/GetMaxMission"
    case redeem = "/svc/api/Redeem"
    case getHistory = "/svc/api/History/{FBID}"
    case getLoadList = "/svc/api/LoadList/{Telco}"
    case getLoadCentral = "/svc/api/LoadCentral"
    case getServices = "/svc/api/GetServices/{ServicesType}"
    case merchantList = "/svc/api/MerchantList"
    case orderProcess = "/svc/api/OrderProcess"
    case referralSMS = "/svc/api/WebInviteSMS"
    case unlockMission = "/svc/api/UnlockMission"
    
    
}

class APIManager {

    static let sharedInstance = APIManager()
    
    private func baseUrl() -> String {
        if Util.environment == Environment.dev {
            return "http://ph.ngage.ph"
        }else {
            return "http://ph.ngage.ph"
        }
    }
    
}

