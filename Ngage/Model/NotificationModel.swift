//
//  NotificationModel.swift
//  Ngage PH
//
//  Created by Mark Angeles on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import CoreData
class NotificationModel: NSObject {
    
    var id: Int = 0
    var title: String = ""
    var body: String = ""
    var rewardType: Int = 0
    var point: Int = 0
    var taskType: Int = 0
    var notifationType: String = ""
    
    convenience init(id: Int, info: [String: Any]) {
        self.init()
        self.id = id
        self.title = info["title"] as? String ?? ""
        self.body = info["body"] as? String ?? ""
        self.rewardType = info["reward_type"] as? Int ?? 0
        self.taskType = info["task_type"] as? Int ?? 0
        self.point = info["point"] as? Int ?? 0
        self.notifationType = info["notification_type"] as? String ?? ""
    }
    
    convenience init(data: NotificationDataModel) {
        self.init()
        self.id = Int(data.id)
        self.point = Int(data.point)
        self.rewardType = Int(data.rewardType)
        self.taskType = Int(data.taskType)
        self.title = data.title ?? ""
        self.body = data.body ?? ""
        self.notifationType = data.notificationType ?? ""
    }

}
