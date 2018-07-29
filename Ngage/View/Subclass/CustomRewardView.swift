//
//  CustomRewardView.swift
//  Ngage PH
//
//  Created by Stratpoint on 29/07/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

protocol CustomRewardViewDelegate {
  func customRewardDidTapButton()
}
class CustomRewardView: UIView {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var contentLabel: UILabel!
  var delegate: CustomRewardViewDelegate?
  
  func config(`with` message: String) {
    contentLabel.text = message
  }
  
  @IBAction func didTapButton(_ sender: UIButton) {
    delegate?.customRewardDidTapButton()
  }
  
}
