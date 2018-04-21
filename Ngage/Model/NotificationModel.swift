//
//  NotificationModel.swift
//  Ngage PH
//
//  Created by Mark Angeles on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

enum NotificationType: String {
    case UP = "UP", //Blast All - New Version with Button Update
    I = "I", //Blast All - with Invite Button
    Default
}

class NotificationModel: NSObject {
    
    var id: Int = 0
    var title: String = ""
    var body: String = ""
    var rewardType: Int = 0
    var point: Int = 0
    var taskType: Int = 0
    var date: String = ""
    var notificationType: NotificationType!
    
    convenience init(id: Int, info: [String: Any]) {
        self.init()
        self.id = id
        self.rewardType = info["gcm.notification.reward_type"] as? Int ?? 0
        self.taskType = info["gcm.notification.task_type"] as? Int ?? 0
        self.point = info["gcm.notification.points"] as? Int ?? 0
        self.notificationType = NotificationType(rawValue: info["gcm.notification.notification_type"] as? String ?? "")
        
        if let notificationContent = info["aps"] as? [String: Any],
            let alert = notificationContent["alert"] as? [String: String] {
            self.title = alert["title"] as? String ?? ""
            self.body = alert["body"] as? String ?? ""
        }
        
        let dateToday = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.date = dateFormatter.string(from: dateToday)
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
        self.notificationType = NotificationType(rawValue: data.notificationType ?? "")
    }
}