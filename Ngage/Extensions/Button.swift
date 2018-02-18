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
        self.isEnabled = false
        self.backgroundColor = UIColor().setColorUsingHex(hex: "#017302")
    }
    
    func setAsWrong() {
        self.isEnabled = false
        self.backgroundColor = UIColor().setColorUsingHex(hex: "#c2231d")
    }
    
    func addLayer() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    func setAsDefault() {
        self.isEnabled = true
        
        self.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
        addLayer()
//        self.backgroundColor = UIColor().setColorUsingHex(hex: "#012b63")
    }
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        setAsCorrect()
        
        layer.add(pulse, forKey: "pulse")
    }
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        setAsWrong()
        
        layer.add(shake, forKey: "position")
    }
    
    func highlight() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }
    
    
    func animateUsing(tag: Int) {
        
        if self.tag == tag {
            self.pulsate()
        }else {
            self.shake()
        }
        
    }
}
