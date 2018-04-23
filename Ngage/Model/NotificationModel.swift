//
//  NotificationModel.swift
//  Ngage PH
//
//  Created by Mark Angeles on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class NotificationModel: NSObject {
    
    var id: Int = 0
    var title: String = ""
    var body: String = ""
    var rewardType: Int = 0
    var point: Int = 0
    var taskType: Int = 0
    var date: String = ""
    var notificationType: String = ""
    
    convenience init(info: [String: AnyObject]) {
        self.init()
        self.id = info["NotifID"] as? Int ?? 0
        self.title = info["title"] as? String ?? ""
        self.body = (info["body"] as? String ?? "").replacingOccurrences(of: "<br\\/>", with: "\n")
        self.notificationType = info["Type"] as? String ?? ""
        self.date = info["DTCreated"] as? String ?? ""
        
        self.rewardType = info["reward_type"] as? Int ?? 0
        self.taskType = info["task_type"] as? Int ?? 0
        self.point = info["points"] as? Int ?? 0
    }
    
    convenience init(data: NotificationDataModel) {
        self.init()
        self.id = Int(data.id)
        self.point = Int(data.point)
        self.rewardType = Int(data.rewardType)
        self.taskType = Int(data.taskType)
        self.title = data.title ?? ""
        self.body = data.body ?? ""
        self.date = data.date ?? ""
        self.notificationType = data.notificationType ?? ""
    }
}
