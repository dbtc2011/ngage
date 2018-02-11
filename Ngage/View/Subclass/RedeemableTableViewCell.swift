//
//  RedeemableTableViewCell.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 08/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class RedeemableTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    
    @IBOutlet weak var btnRedeem: UIButton!
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContent.layer.cornerRadius = 5.0
        viewContent.layer.shadowColor = UIColor.black.cgColor
        viewContent.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewContent.layer.shadowOpacity = 0.2
        
        btnRedeem.layer.cornerRadius = btnRedeem.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

}
