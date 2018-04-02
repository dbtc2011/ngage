//
//  MarketPlaceAdsView.swift
//  Ngage PH
//
//  Created by Mark Angeles on 03/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
protocol MarketPlaceAdsViewDelegate {
    func marketPlaceDidClose()
    func marketPlaceShouldOpenMarketPlace()
}
class MarketPlaceAdsView: UIView {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPoints: UILabel!
    @IBOutlet weak var buttonMarket: UIButton!
    var delegate: MarketPlaceAdsViewDelegate?
    
    func setupContent(points: String, title: String) {
        if let viewHolder = self.viewWithTag(100) {
            viewHolder.layer.cornerRadius = 15
        }
        labelTitle.text = title
        var point = ""
        if points == "1" || points == "0" {
            point = "\(points)\npoint"
        }else {
            point = "\(points)\npoints"
        }
        labelPoints.text = point
        buttonMarket.layer.cornerRadius = 12

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: - Button Actions
    
    @IBAction func marketButtonClicked(_ sender: UIButton) {
        delegate?.marketPlaceShouldOpenMarketPlace()
    }
    
    @IBAction func closeButtonclicked(_ sender: UIButton) {
        delegate?.marketPlaceDidClose()
    }
    
    
}
