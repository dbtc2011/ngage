//
//  Redeemable.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 08/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class RedeemableModel: NSObject {
    var id = 0
    var name = ""
    var pointsRequired = 0
}

class ServiceRedeemableModel: RedeemableModel {
    var filePath = ""
    var optimizedPic = ""
    var artist = ""
}

class LoadListRedeemableModel: RedeemableModel {
    var code = ""
    var loadDescription = ""
}
