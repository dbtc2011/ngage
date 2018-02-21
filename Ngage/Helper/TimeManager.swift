//
//  TimeManager.swift
//  Ngage PH
//
//  Created by Mark Louie Angeles on 21/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TimeManagerDelegate {
    func timeManagerUpdating(time : String)
}
class TimeManager: NSObject {
    
    static let sharedInstance = TimeManager()
    private var currentDay : String = ""
    private var currentTime : String = ""
    var midnightDate : Date!
    var currentDate : Date!
    var serverDate : Date!
    var startedMissionCode : Int = 0
    private var timeRemaining = ""
    
    
    func setTimer() {
        RegisterService.getServerTime() { (result, error) in
            if error == nil {
                print("SERVER TIME:")
                if let sdateTime = result!["Sdatetime"].string {
                    let dateComponents = sdateTime.components(separatedBy: ".")
                    let dateTimeComponents = dateComponents[0].components(separatedBy: "T")
                    self.currentDay = dateTimeComponents[0]
                    self.currentTime = dateTimeComponents[1]
                    self.timeRemaining = dateComponents[0] + " +0000"
                    self.logDate()
                }
                
            }else {
                print("ERROR GETTING SERVER TIME")
            }
        }
    }
    
    private func logDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        let timeMidnight = "\(currentDay)T00:00:00 +0000"
        if let date = formatter.date(from: timeMidnight) {
            midnightDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            if let serverDates = formatter.date(from: timeRemaining) {
                serverDate = serverDates
                currentDate = Date()
            }
        }
    }
    
  
}

