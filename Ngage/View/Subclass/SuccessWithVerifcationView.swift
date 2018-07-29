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
  
  func config(`for` task: TaskModel, totalPoint: Int) {
    var pointsEarned = ""
    let points = task.isReward
    if points == "0" || points == "1" {
      pointsEarned = pointsEarned + "pt"
    }else {
      pointsEarned = pointsEarned + "pts"
    }
    var totalEarnedPoints = ""
    if totalPoint == 0 || totalPoint == 1 {
      totalEarnedPoints = "\(totalPoint)pt"
    }else {
      totalEarnedPoints = "\(totalPoint)pts"
    }
    if Util.pendingReward(for: task) {
      content.text = "Sorry, you have lost your chance of earning 2 points"
    } else {
      content.text = "You have been rewarded with \(pointsEarned) for getting a perfect score on this task.\n\nYour total point is \(totalEarnedPoints)"
    }
    
    let muttAttString = NSMutableAttributedString(string: content.text!)
    var targetRange = (content.text! as NSString).range(of: totalEarnedPoints)
    
    if targetRange.location != NSNotFound {
      muttAttString.addAttribute(NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue), value: UIFont.boldSystemFont(ofSize: 36), range: targetRange)
    }
    
    targetRange = (content.text! as NSString).range(of: pointsEarned)
    if targetRange.location != NSNotFound {
      muttAttString.addAttribute(NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue), value: UIColor.green, range: targetRange)
    }
    content.attributedText = muttAttString
    viewContent.layer.cornerRadius = 10
    button.layer.cornerRadius = 22
  }
  
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
    }else if type == "install" {
      content.text = "You will earn an additional {point} for finishing this task."
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
