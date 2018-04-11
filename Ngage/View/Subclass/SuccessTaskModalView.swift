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
    var selectedTask: TaskModel!
    var delegate : CustomModalViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setupContents(pointsTotal : String, pointsEarned: Int) {
        let attributes : [String : Any] = [NSAttributedStringKey.font.rawValue : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor.rawValue : UIColor.blue]

        var earnedValue = "\(pointsEarned)\npoint"
        var noteValue = "\(pointsEarned)pt"
        if pointsEarned > 1 {
            earnedValue = "\(pointsEarned)\npoints"
            noteValue = "\(pointsEarned)pts"
        }
        containerView.layer.cornerRadius = 10
        earnedPoints.text = earnedValue
        note.text = note.text!.replacingOccurrences(of: "{point}", with: noteValue)
        if self.selectedTask.code == 6 {
            totalPoints.text = totalPoints.text!.replacingOccurrences(of: "Your total point is {point}", with: "")
            earnedPoints.text = "2\npts"
            note.text = "You will earn an additional 2pts for every successful referral."
        }else {
            totalPoints.text = totalPoints.text!.replacingOccurrences(of: "{point}", with: pointsTotal)
        }
        
        button.layer.cornerRadius = 22
        earnedContainer.layer.cornerRadius = earnedContainer.bounds.size.width/2
        earnedContainer.layer.masksToBounds = true
        earnedContainer.clipsToBounds = true
//        earnedPoints.layer.cornerRadius = 65
        earnedPoints.layer.cornerRadius = earnedPoints.bounds.size.width/2
        earnedPoints.layer.masksToBounds = true
        earnedPoints.clipsToBounds = true
        
        var muttAttString = NSMutableAttributedString(string: earnedPoints.text!)
        var targetRange = (earnedPoints.text! as NSString).range(of: "\(pointsEarned)")
        
        if targetRange.location != NSNotFound {
            muttAttString.addAttribute(NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue), value: UIFont.boldSystemFont(ofSize: 22), range: targetRange)
            earnedPoints.attributedText = muttAttString
        }
        
        muttAttString = NSMutableAttributedString(string: note.text!)
        targetRange = (note.text! as NSString).range(of: "\(noteValue)")
        if targetRange.location != NSNotFound {
            muttAttString.addAttribute(NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue), value: UIColor.green, range: targetRange)
            note.attributedText = muttAttString
        }
    }
    @IBAction func buttonClicked(_ sender: UIButton) {
        delegate?.didTapOkayButton(tag: 2)
    }
}
