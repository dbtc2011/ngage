//
//  APIManager.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 29/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    
    case register(parameter : Parameters)
    case validateRegistration(parameter: Parameters)
    case resendVerificationCode(parameter: Parameters)
    case sendPinCode(parameter : Parameters)
    case getMission(parameter : Parameters)
    case getTaskContent(parameter : Parameters)
    case insertRecord(parameter : Parameters)
    case uploadPicture(parameter : Parameters)
    case validateMission(parameter : Parameters)
    case getServerTime(parameter : Parameters)
    case getMaxMission(parameter : Parameters)
    case redeem(parameter : Parameters)
    case getHistory(parameter : Parameters)
    case getLoadList(parameter : Parameters)
    case getLoadCentral(parameter : Parameters)
    case getServices(parameter : Parameters)
    case merchantList(parameter : Parameters)
    case orderProcess(parameter : Parameters)
    case referralSMS(parameter : Parameters)
    case unlockMission(parameter : Parameters)
    case merchantInfo(parameter : Parameters)

    var baseURL : String {
        if Util.environment == Environment.dev {
            return "https://ph.ngage.ph"
        }else {
            return "https://ph.ngage.ph"
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case .getHistory, .resendVerificationCode, .getLoadList, .getServices, .getServerTime:
            return .get
        default:
            return .post
        }
    }
    
    struct Endpoint {
        static let register = "svc/api/Registration"
        static let validateRegistration = "svc/api/ValidateREG"
        static let sendPinCode = "svc/api/SendPincode"
        static let resendVerificationCode = "svc/api/ResendPinCode/{FBID}"
        static let getMission = "svc/api/GetMission"
        static let getTaskContent = "svc/api/GETContent"
        static let insertRecord = "svc/api/INSERTRecord"
        static let uploadPicture = "svc/api/Upload"
        static let validateMission = "svc/api/MaxUser/{MissionID}"
        static let getServerTime = "api/ServerTime"
        static let getMaxMission = "api/GetMaxMission"
        static let redeem = "svc/api/Redeem"
        static let getHistory = "svc/api/History/{FBID}"
        static let getLoadList = "svc/api/LoadList/{Telco}"
        static let getLoadCentral = "svc/api/LoadCentral"
        static let getServices = "svc/api/GetServices/{ServicesType}"
        static let merchantList = "svc/api/MerchantList"
        static let orderProcess = "svc/api/OrderProcess"
        static let referralSMS = "svc/api/WebInviteSMS"
        static let unlockMission = "svc/api/UnlockMission"
        static let merchantInfo = "svc/api/MerchantInfo"
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let result: (path: String, parameters: Parameters?) = {
            switch self {
            case let .register(parameters):
                return (Router.Endpoint.register, parameters)
    
            case let .validateRegistration(parameters):
                return (Router.Endpoint.validateRegistration, parameters)
                
            case let .sendPinCode(parameters):
                return (Router.Endpoint.sendPinCode, parameters)
                
            case let .resendVerificationCode(parameters):
                return (Router.Endpoint.resendVerificationCode, parameters)
                
            case let .getMission(parameters):
                return (Router.Endpoint.getMission, parameters)
                
            case let .getTaskContent(parameters):
                return (Router.Endpoint.getTaskContent, parameters)
                
            case let .insertRecord(parameters):
                return (Router.Endpoint.insertRecord, parameters)
                
            case let .uploadPicture(parameters):
                return (Router.Endpoint.uploadPicture, parameters)
                
            case let .validateMission(parameters):
                return (Router.Endpoint.validateMission, parameters)
                
            case let .getServerTime(parameters):
                return (Router.Endpoint.getServerTime, parameters)
                
            case let .getMaxMission(parameters):
                return (Router.Endpoint.getMaxMission, parameters)
                
            case let .redeem(parameters):
                return (Router.Endpoint.redeem, parameters)
                
            case let .getHistory(parameters):
                return (Router.Endpoint.getHistory, parameters)
                
            case let .getLoadList(parameters):
                return (Router.Endpoint.getLoadList, parameters)
                
            case let .getLoadCentral(parameters):
                return (Router.Endpoint.getLoadCentral, parameters)
                
            case let .getServices(parameters):
                return (Router.Endpoint.getServices, parameters)
                
            case let .merchantList(parameters):
                return (Router.Endpoint.merchantList, parameters)
                
            case let .orderProcess(parameters):
                return (Router.Endpoint.orderProcess, parameters)
                
            case let .referralSMS(parameters):
                return (Router.Endpoint.referralSMS, parameters)
                
            case let .unlockMission(parameters):
                return (Router.Endpoint.unlockMission, parameters)
                
            case let .merchantInfo(parameters):
                return (Router.Endpoint.merchantInfo, parameters)
            }
        }()
        
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent("\(result.path)"))
        urlRequest.httpMethod = method.rawValue
        print("method = \(method.rawValue)")
        if method.rawValue == "GET" {
            print("DID set as Get ------> \(url)")
            var getParameter = result.path
            if let parameters = result.parameters {
                for key in parameters.keys {
                    getParameter = getParameter.replacingOccurrences(of: key, with: parameters[key] as! String)
                }
            }
            let urlPath = try (baseURL + "/\(getParameter)").asURL()
            return URLRequest(url: urlPath)
//            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        } else {
            
            print("DID set as POST ------> \(url)")
            urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            if let parameters = result.parameters {
                urlRequest.httpBody = asString(jsonDictionary: parameters).data(using: .utf8, allowLossyConversion: false)
            }
            return urlRequest
        }
    }
    
    func asString(jsonDictionary: Parameters) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
}

class RequestTask {
    private(set) var urlRequest: URLRequestConvertible!
    
    private static let sessionManager = SessionManager()
    
    convenience init(urlRequest: URLRequestConvertible) {
        self.init()
        self.urlRequest = urlRequest
    }

    /**
     Main handler of all the requests
     
     - Parameter url: a type conforming to `URLRequestConvertible`.
     - Parameter authenticate: boolean that identifies if the `URLRequest` needs an access token.
     - Parameter completion: a callback that contains and an optional `JSON` or an optional `NSError`, depending if the the requests succeeded or not.
     
     - Returns: an instance of the `URLRequest` created with the supplied parameters.
     */
    @discardableResult
    final func perform(_ success: @escaping SuccessBlock, failure: @escaping FailureBlock) -> URLRequest? {
        
        return RequestTask.sessionManager.request(urlRequest).responseJSON(completionHandler: { (response) in
            // Do something with the response, example, convert error messages to native Error type.
            
            if let error = response.error {
                failure(self.makeError(with: error.localizedDescription))
                return
            }
            
            if let response = response.result.value {
                success(response)
            } else {
                failure(self.makeError(with: "API error"))
            }
        }).request
    }
    
    private func makeError(with reason: String? = nil) -> NSError {
        let errorCode = 500
        let reason = reason ?? "Network Error"
        
        return NSError(domain: "Ngage",
                       code: errorCode,
                       userInfo: [NSLocalizedDescriptionKey: reason])
    }
        
}


