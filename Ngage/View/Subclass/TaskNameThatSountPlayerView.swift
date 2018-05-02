//
//  TaskNameThatSountPlayerView.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 11/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
protocol TaskNameThatSountPlayerViewDelegate {
    
    func didTapPlay()
    
}
class TaskNameThatSountPlayerView: UIView {

    @IBOutlet weak var buttonLeading: NSLayoutConstraint!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var title: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func playButtonClicked(_ sender: UIButton) {
        
    }
    

}
