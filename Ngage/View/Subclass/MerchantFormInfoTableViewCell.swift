//
//  MerchantFormInfoTableViewCell.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 19/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MerchantFormInfoTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var txtInfo: UITextField!
    
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
