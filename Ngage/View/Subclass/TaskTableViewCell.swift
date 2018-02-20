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
        switch task.state {
        case TaskStatus.enabled.rawValue:
            rightIcon.image = UIImage(named: "ic_reward_enabled")
            leftIcon.image = nil
            leftIcon.backgroundColor = color
            taskIcon.backgroundColor = color
            title.textColor = color

        case TaskStatus.disabled.rawValue:
            rightIcon.image = UIImage(named: "ic_reward_disabled")
            leftIcon.image = nil
            leftIcon.backgroundColor = UIColor.lightGray
            taskIcon.backgroundColor = UIColor.lightGray
            title.textColor = UIColor.lightGray
            
        case TaskStatus.done.rawValue:
            rightIcon.image = UIImage(named: "ic_reward_done")
            leftIcon.image = UIImage(named: "ic_task_done")
            leftIcon.backgroundColor = color
            leftIcon.layer.masksToBounds = true
            leftIcon.clipsToBounds = true
            containerView.backgroundColor = color
            title.textColor = UIColor.white
            taskIcon.backgroundColor = UIColor.white
            
        default:
            rightIcon.image = UIImage(named: "ic_reward_disabled")

        }
        title.text = task.info
        labelReward.text = task.rewardInfo
        rightIcon.layer.cornerRadius = 20
        leftIcon.layer.cornerRadius = 15
    }
    


}
