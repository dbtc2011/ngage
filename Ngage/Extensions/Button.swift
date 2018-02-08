//
//  Button.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 06/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    
    func setAsCorrect() {
        self.backgroundColor = UIColor().setColorUsingHex(hex: "#017302")
    }
    
    func setAsWrong() {
        self.backgroundColor = UIColor().setColorUsingHex(hex: "#c2231d")
    }
    
    func setAsDefault() {
        self.backgroundColor = UIColor().setColorUsingHex(hex: "#012b63")
    }
}
