//
//  Mission.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 30/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

struct MissionModel {
    var code = 0
    var userId = ""
    
    var brand = ""
    var colorBackground = ""
    var colorPrimary = ""
    var colorSecondary = ""
    var createdBy = ""
    var endDate = ""
    var imageUrl = ""
    var imageTask : DownloadImageClass?
    var isClaimed = false
    var pointsRequiredToUnlock = ""
    var reward = ""
    var rewardDetails = ""
    var rewardInfo = ""
    var rewardType = ""
    var startDate = ""
    var title = ""
    var tasks = [TaskModel]()
}
