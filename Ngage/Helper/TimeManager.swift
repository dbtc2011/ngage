//
//  TimeManager.swift
//  Ngage PH
//
//  Created by Mark Louie Angeles on 21/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import SwiftyJSON

class TimeManager: NSObject {
    
    static let sharedInstance = TimeManager()
    private var currentDay : String = ""
    private var currentTime : String = ""
    private var midnightDate : Date!
    private var currentDate : Date!
    private var currentCounter : Double!
    var timeRemaining : String = ""
    var startedMissionCode : Int = 0
    
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
    
    func logDate() {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        let timeMidnight = "\(currentDay)T00:00:00 +0000"
        if let date = formatter.date(from: timeMidnight) {
            midnightDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            print("Midnight Date = \(date)")
            if let serverDate = formatter.date(from: timeRemaining) {
                currentDate = serverDate
                currentCounter = Double(midnightDate.timeIntervalSince(currentDate))
                runTimer()
            }
        }
        print("Time = \(timeRemaining)")
        
    }
    
    func runTimer() {
        let timeInterval = TimeInterval(exactly: currentCounter)
        print(timeInterval!.hoursMinutesSecondMS)
        self.timeRemaining = timeInterval!.hoursMinutesSecondMS
        if currentCounter <= 0 {
            
        }else {
            currentCounter = currentCounter - 1
            let when = DispatchTime.now() + 1.0
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.runTimer()
            }
        }
//        let timeInterval =
    }
}


