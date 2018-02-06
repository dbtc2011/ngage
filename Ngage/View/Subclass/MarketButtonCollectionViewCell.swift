//
//  MarketButtonCollectionViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class MarketButtonCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewSelectionIndicator: UIView!
    
    //MARK: - Methods
    
    func setupContent(withTitle title: String) {
        labelTitle.text = title
    }
    
    func setSelectionIndicator(isHidden hidden: Bool) {
        viewSelectionIndicator.isHidden = hidden
    }
}
