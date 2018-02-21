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
