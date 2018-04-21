//
//  NotificationTableViewCell.swift
//  Ngage PH
//
//  Created by cybilltek on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - Methods
    
    func setupCell(withNotificationModel notification: NotificationModel) {
        lblTitle.text = notification.title
        lblMessage.text = notification.body
        lblDate.text = notification.date
    }
    
}
