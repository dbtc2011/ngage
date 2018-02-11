//
//  Market.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 08/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

//MARK: - Enums

enum MarketType {
    case Services, LoadList, Merchant
}

enum ServicesType: String {
    case Wallpaper = "WALLPAPER", Ringtone = "RBT"
}

enum LoadListType: String {
    case Globe = "GLOBE", Smart = "SMART", Sun = "SUN", MobileLegends = "MOBILELEGENDS"
}

enum MerchantType: String {
    case Food = "food", Shop = "shop", Health = "health", Travel = "travel", Service = "service"
}

//MARK: - Classes

class MarketModel: NSObject {
    var marketId = 0
    var name = ""
    var marketType: MarketType!
    
    var redeemables: [RedeemableModel]!
}

class LoadListMarketModel: MarketModel {
    var type: LoadListType!
}

class ServiceMarketModel: MarketModel {
    var type: ServicesType!
}

class MerchantMarketModel: MarketModel {
    var type: MerchantType!
}
