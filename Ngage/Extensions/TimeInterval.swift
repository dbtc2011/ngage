//
//  TimeInterval.swift
//  Ngage PH
//
//  Created by Mark Louie Angeles on 21/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d", minute, second)
    }
    
    var hoursMinutesSecondMS: String {
        return String(format:"%d:%d:%02d",hour, minute, second)
    }
    
    func remainingDays(from: Date, to: Date) -> String {
        var remainingDaysHours = ""
        var dayUom = "days"
        var hourUom = "hours"
        var minuteUom = "minutes"
        var secondUom = "seconds"
        
        let days = to.interval(ofComponent: Calendar.Component.day, fromDate: from)
        if days <= 1 {
            dayUom = "day"
        }
        if hour <= 1 {
            hourUom = "hour"
        }
        if minute <= 1 {
            minuteUom = "minute"
        }
        if second <= 1 {
            secondUom = "second"
        }
        remainingDaysHours = "\(days) \(dayUom) \(hour) \(hourUom) \(minute) \(minuteUom) \(second) \(secondUom)"
        return remainingDaysHours
    }
    var hour: Int {
        return Int((self/3600).truncatingRemainder(dividingBy: 60))
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}
