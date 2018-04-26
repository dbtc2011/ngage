//
//  SuccessWithVerifcationView.swift
//  Ngage PH
//
//  Created by Marielle Miranda on 4/15/18.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class SuccessWithVerifcationView: UIView {

    @IBOutlet var viewBackground: UIView!
    @IBOutlet var viewContent: UIView!
    @IBOutlet var content: UILabel!
    @IBOutlet var button: UIButton!
    var type = "normal"
    var delegate : CustomModalViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: - Public Function
    func setupContent(points: String) {
        
        var pointsEarned = points
        if points == "0" || points == "1" {
            pointsEarned = pointsEarned + "pt"
        }else {
            pointsEarned = pointsEarned + "pts"
        }
        if points == "" {
            content.text = "Thank you for completing this task."
        }
        if type == "referral" {
            content.text = "You will earn an additional {point} for every successful referral"
        }
        content.text = content.text!.replacingOccurrences(of: "{point}", with: pointsEarned)
        let muttAttString = NSMutableAttributedString(string: content.text!)
        let targetRange = (content.text! as NSString).range(of: "\(pointsEarned)")
        
        if targetRange.location != NSNotFound {
            muttAttString.addAttribute(NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue), value: UIColor.green, range: targetRange)
            content.attributedText = muttAttString
        }
        viewContent.layer.cornerRadius = 10
        button.layer.cornerRadius = 22
    }
    
    
    //MARK: - Button Action
    @IBAction func didTapOkay(_ sender: UIButton) {
        delegate?.didTapOkayButton(tag: 2)
    }
    
}
