//
//  TaskSoundView.swift
//  Ngage PH
//
//  Created by Stratpoint on 03/05/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class TaskSoundView: UIView {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var labelContent: UILabel!
    var delegate : TaskNameThatSountPlayerViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func didTapPlay(_ sender: UIButton) {

        delegate?.didTapPlay()
    }
    

}
