//
//  TaskTableViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

enum TaskStatus : Int {
    case enabled = 1, disabled = 0, done = 2
}

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var taskIcon: UIImageView!
    @IBOutlet weak var labelReward: UILabel!
    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUsing(task : TaskModel, color: UIColor) {
        containerView.layer.cornerRadius = 5.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.2
        containerView.backgroundColor = UIColor.white
        
        taskIcon.layer.masksToBounds = true
        taskIcon.clipsToBounds = true
        
        switch task.type {
        case 1:
            taskIcon.image = UIImage(named: "ic_task_profile")
        case 2:
            taskIcon.image = UIImage(named: "ic_task_survey")
        case 3:
            taskIcon.image = UIImage(named: "ic_task_watch")
        case 4:
            taskIcon.image = UIImage(named: "ic_task_game")
        case 5:
            taskIcon.image = UIImage(named: "ic_task_share")
        case 6:
            taskIcon.image = UIImage(named: "ic_task_invitesms")
        case 7:
            taskIcon.image = UIImage(named: "ic_task_quiz")
        case 8:
            taskIcon.image = UIImage(named: "ic_task_tone")
        case 9:
            taskIcon.image = UIImage(named: "ic_task_invitesms")
        case 10:
            taskIcon.image = UIImage(named: "ic_task_uploadphoto")
        case 11:
            taskIcon.image = UIImage(named: "ic_task_upload_share")
        case 16:
            taskIcon.image = UIImage(named: "ic_task_watch_share")
        case 17:
            taskIcon.image = UIImage(named: "ic_task_quiz")
        default:
            taskIcon.image = UIImage(named: "ic_task_profile")
        }
        switch task.state {
        case TaskStatus.enabled.rawValue:
            rightIcon.image = UIImage(named: "ic_reward_enabled")
            leftIcon.image = nil
            leftIcon.backgroundColor = color
            //ic_task_interest_48x48
            title.textColor = color
            containerView.backgroundColor = UIColor.white
            taskIcon.backgroundColor = UIColor.white
            taskIcon.image = taskIcon.image!.withRenderingMode(.alwaysTemplate)
            taskIcon.tintColor = color

        case TaskStatus.disabled.rawValue:
            rightIcon.image = UIImage(named: "ic_reward_disabled")
            leftIcon.image = nil
            leftIcon.backgroundColor = UIColor.lightGray
            title.textColor = UIColor.lightGray
            taskIcon.layer.cornerRadius = 5
            containerView.backgroundColor = UIColor.white
            taskIcon.backgroundColor = UIColor.white
            taskIcon.image = taskIcon.image!.withRenderingMode(.alwaysTemplate)
            taskIcon.tintColor = UIColor.lightGray
        case TaskStatus.done.rawValue:
            rightIcon.image = UIImage(named: "ic_reward_done")
            leftIcon.image = UIImage(named: "ic_task_done")
            leftIcon.backgroundColor = color
            leftIcon.layer.masksToBounds = true
            leftIcon.clipsToBounds = true
            containerView.backgroundColor = color
            title.textColor = UIColor.white
            taskIcon.backgroundColor = color
            
        default:
            rightIcon.image = UIImage(named: "ic_reward_disabled")

        }
        title.text = task.title
        labelReward.text = getRewardWithUOM(reward: task.reward)
        rightIcon.layer.cornerRadius = 20
        leftIcon.layer.cornerRadius = 15
        
        
        
    }
    
    func getRewardWithUOM(reward: String) -> String {
        
        if reward == "0" || reward == "1" {
            return "\(reward)pt"
        }else {
            return "\(reward)pts"
        }

    }
    
}
