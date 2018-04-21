//
//  NotificationDetailButtonTableViewCell.swift
//  Ngage PH
//
//  Created by cybilltek on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

protocol NotificationDetailButtonTableViewCellDelegate {
    func didClickUpdateApplication()
    func didClickInviteFriends()
}

class NotificationDetailButtonTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var btnAction: UIButton!
    
    var delegate: NotificationDetailButtonTableViewCellDelegate!
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - IBAction Delegate
    
    @IBAction func didClickButton(_ sender: UIButton) {
        if sender.tag == 1 {
            delegate.didClickUpdateApplication()
        } else {
            delegate.didClickInviteFriends()
        }
    }
}
