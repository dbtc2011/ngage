//
//  SuccessTaskModalView.swift
//  Ngage PH
//
//  Created by Mark Louie Angeles on 03/03/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class SuccessTaskModalView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var earnedContainer: UIView!
    @IBOutlet weak var earnedPoints: UILabel!
    var delegate : CustomModalViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setupContents(pointsTotal : String, pointsEarned: Int) {
        
        var earnedValue = "\(pointsEarned)point"
        var noteValue = "\(pointsEarned)pt"
        if pointsEarned > 1 {
            earnedValue = "\(pointsEarned)points"
            noteValue = "\(pointsEarned)pts"
        }
        containerView.layer.cornerRadius = 10
        earnedPoints.text = earnedValue
        note.text = note.text!.replacingOccurrences(of: "{point}", with: noteValue)
        totalPoints.text = totalPoints.text!.replacingOccurrences(of: "{point}", with: pointsTotal)
        button.layer.cornerRadius = 22
        earnedContainer.layer.cornerRadius = earnedContainer.bounds.size.width/2
        earnedContainer.layer.masksToBounds = true
        earnedContainer.clipsToBounds = true
//        earnedPoints.layer.cornerRadius = 65
        earnedPoints.layer.cornerRadius = earnedPoints.bounds.size.width/2
        earnedPoints.layer.masksToBounds = true
        earnedPoints.clipsToBounds = true
    }
    @IBAction func buttonClicked(_ sender: UIButton) {
        delegate?.didTapOkayButton(tag: 2)
    }
}
