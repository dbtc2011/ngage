//
//  CustomProgressView.swift
//  Ngage PH
//
//  Created by Mark Angeles on 01/04/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import CircleProgressView

class CustomProgressView: UIView {

    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var backgroundProgress: CircleProgressView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setupProgressColor(color: UIColor) {
        self.backgroundColor = UIColor.clear
        
        backgroundProgress.trackBackgroundColor = UIColor.clear
        backgroundProgress.backgroundColor = UIColor.clear
        backgroundProgress.contentView.backgroundColor = UIColor.clear
        backgroundProgress.centerFillColor = UIColor.clear
        backgroundProgress.trackFillColor = UIColor.white
        
        progressView.trackBackgroundColor = UIColor.clear
        progressView.backgroundColor = UIColor.clear
        progressView.contentView.backgroundColor = UIColor.clear
        progressView.centerFillColor = UIColor.clear
        progressView.trackFillColor = color
    }
    
    func setupContent(currentProgress: Double) {
        progressLabel.text = "\(Int(currentProgress))%"
        progressView.setProgress(currentProgress, animated: false)
        print("Animate progress view!")
    }

}
