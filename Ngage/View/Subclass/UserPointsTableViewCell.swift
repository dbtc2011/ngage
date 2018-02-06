//
//  UserPointsTableViewCell.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 04/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class UserPointsTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblRedeemed: UILabel!
    @IBOutlet weak var lblMissions: UILabel!
    
    //MARK: - View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let labels = [lblPoints, lblRedeemed, lblMissions]
        for label in labels {
            guard label != nil else { break }
            label!.layer.cornerRadius = 3.0
            
            label!.superview!.layer.shadowColor = UIColor.black.cgColor
            label!.superview!.layer.shadowOffset = CGSize(width: 0, height: 2)
            label!.superview!.layer.shadowOpacity = 0.2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Methods
    
    func setPointsInfo(withPoints points: String, withRedeemed redeemed: String, withMissions missions: String) {
        lblPoints.text = points
        lblRedeemed.text = redeemed
        lblMissions.text = missions
    }

}
