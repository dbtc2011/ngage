//
//  NotificationDetailMessageTableViewCell.swift
//  Ngage PH
//
//  Created by cybilltek on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class NotificationDetailMessageTableViewCell: UITableViewCell {

    //MARK: - Properties
    
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
    
    func setContent(withNotificationModel notification: NotificationModel) {
        let titleAttribute = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 20.0)!]
        let bodyAttribute = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Light", size: 17.0)!]
        
        let attributedContent = NSMutableAttributedString(string: notification.title, attributes: titleAttribute)
        attributedContent.append(NSAttributedString(string: "\n\n\(notification.body)", attributes: bodyAttribute))
        
        lblMessage.attributedText = attributedContent
        lblMessage.sizeToFit()
    }
}
