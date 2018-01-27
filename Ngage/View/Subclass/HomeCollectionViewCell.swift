//
//  HomeCollectionViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
protocol HomeCollectionViewCellDelegate {
    func homeDidTapStart()
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    var delegate : HomeCollectionViewCellDelegate?
    
    func setupContents(color : UIColor) {
        button.layer.cornerRadius = 5
        button.backgroundColor = color
        image.backgroundColor = color
    }
    @IBAction func didTapStart(_ sender: UIButton) {
        delegate?.homeDidTapStart()
    }
}
