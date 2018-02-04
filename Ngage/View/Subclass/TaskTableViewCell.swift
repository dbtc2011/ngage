//
//  TaskTableViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
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
        title.text = task.info
        leftIcon.backgroundColor = color
        rightIcon.backgroundColor = color
        
        rightIcon.layer.cornerRadius = 20
        leftIcon.layer.cornerRadius = 15
    }


}
