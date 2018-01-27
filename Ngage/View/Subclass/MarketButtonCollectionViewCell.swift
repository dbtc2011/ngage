//
//  MarketButtonCollectionViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MarketButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    
    
    func setupContent(title : String) {
        labelTitle.text = title
    }
}
