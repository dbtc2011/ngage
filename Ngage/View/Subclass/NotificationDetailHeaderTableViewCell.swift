//
//  NotificationDetailHeaderTableViewCell.swift
//  Ngage PH
//
//  Created by cybilltek on 21/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class NotificationDetailHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var lblDate: UILabel!

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
    
    func setDate(withDate date: String) {
        lblDate.text = date
    }
}
