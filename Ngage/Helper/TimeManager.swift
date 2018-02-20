//
//  TimeManager.swift
//  Ngage PH
//
//  Created by Mark Louie Angeles on 21/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation

class TimeManager: NSObject {
    
    static let sharedInstance = TimeManager()
    
    func setTimer() {
        
        RegisterService.getServerTime() { (result, error) in
            if error == nil {
                
                print("SERVER TIME = \(result)")
            }else {
                print("ERROR GETTING SERVER TIME")
            }
        }
    }
}


