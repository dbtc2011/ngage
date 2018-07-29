//
//  TermsAndConditionView.swift
//  Ngage PH
//
//  Created by Stratpoint on 29/07/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
protocol TermsAndConditionViewDelegate {
  func termsDidSelect(action: String)
}
class TermsAndConditionView: UIView {

  @IBOutlet weak var buttonTAC: UIButton!
  var delegate: TermsAndConditionViewDelegate?
  
  
  //MARK: - Button Actions
  @IBAction func didTapTAC(_ sender: UIButton) {
    delegate?.termsDidSelect(action: sender.title(for: UIControlState.normal) ?? "")
  }
  @IBAction func didTapTermsAndConditions(_ sender: UIButton) {
    delegate?.termsDidSelect(action: sender.title(for: UIControlState.normal) ?? "Terms and Conditions")
  }
  
  @IBAction func didTapPrivacy(_ sender: UIButton) {
    delegate?.termsDidSelect(action: sender.title(for: UIControlState.normal) ?? "Privacy Policy")
  }
}
