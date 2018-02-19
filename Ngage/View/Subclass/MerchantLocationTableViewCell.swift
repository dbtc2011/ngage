//
//  MerchantLocationTableViewCell.swift
//  Ngage PH
//
//  Created by Mary Marielle Miranda on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MerchantLocationTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblContactNumbers: UILabel!
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

}
