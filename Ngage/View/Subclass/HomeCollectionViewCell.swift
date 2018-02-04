//
//  HomeCollectionViewCell.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 25/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
protocol HomeCollectionViewCellDelegate {
    func homeDidTapStart(tag: Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    var delegate : HomeCollectionViewCellDelegate?
    
    func setupContents(mission : MissionModel) {
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor().setColorUsingHex(hex: mission.colorBackground)
        if mission.imageTask!.data != nil {
            if let imageData = UIImage(data: mission.imageTask!.data!) {
                image.image = imageData
                
            }
        }
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.clipsToBounds = true
    }
    
    @IBAction func didTapStart(_ sender: UIButton) {
        delegate?.homeDidTapStart(tag: self.tag)
    }
}
