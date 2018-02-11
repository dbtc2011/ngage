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

class MerchantRedeemableModel: RedeemableModel {
    var isVirtual = "False"
    var detailsUrl = ""
    var logoUrl = ""
    var tagline = ""
    var subcategory = ""
    var locationCount = 0
    var denominationCount = 0
    var hasCustom = "False"
    var hasMarkup = "False"
    var maximumPointsRequired = 0
}
