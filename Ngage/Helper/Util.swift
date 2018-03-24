//
//  Util.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import Foundation
import UIKit

enum Environment {
    case dev, prod
}
struct Util {
    
    static let environment = Environment.prod
    static func setNavigationBar(color : UIColor) {
        UITabBar.appearance().backgroundColor = color
        UINavigationBar.appearance().backgroundColor = color
        UINavigationBar.appearance().isTranslucent = false
    }
}
