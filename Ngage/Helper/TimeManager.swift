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
    private var timeRemaining = ""
    var hasStartedMission = false
    var hasFinishedFirstTask = false
    var shouldEditMission = false
    var midnightDate : Date!
    var currentDate : Date!
    var serverDate : Date!
    var shouldSaveDate = false
    
    func setTimer() {
        
        if hasStartedMission == false {
            // should not call time?
        }
        RegisterService.getServerTime() { (result, error) in
            if error == nil {
                print("SERVER TIME:")
                if let sdateTime = result!["Sdatetime"].string {
                    let dateComponents = sdateTime.components(separatedBy: ".")
                    let dateTimeComponents = dateComponents[0].components(separatedBy: "T")
                    self.currentDay = dateTimeComponents[0]
                    self.currentTime = dateTimeComponents[1]
                    self.timeRemaining = dateComponents[0] + " +0000"
                    if !self.shouldSaveDate {
                        if let lastMissionString = UserDefaults.standard.string(forKey: Keys.MissionStartDate) {
                            let arrayLastMission = lastMissionString.components(separatedBy: "T")
                            print("Day to check = \(self.currentDay) = \(arrayLastMission[0])")
                            if self.currentDay != arrayLastMission[0] {
                                UserDefaults.standard.set(false, forKey: Keys.keyHasStartedMission)
                            }
                        }else {
                            UserDefaults.standard.set(false, forKey: Keys.keyHasStartedMission)
                        }
                        
                    }
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
                if shouldSaveDate {
                    UserDefaults.standard.setValue(timeRemaining, forKey: Keys.MissionStartDate)
                    shouldSaveDate = false
                }
                serverDate = serverDates
                currentDate = Date()
            }
        }
    }
    
    func resetTimeStamp() {
        UserDefaults.standard.setValue(timeRemaining, forKey: Keys.MissionStartDate)
    }
}


