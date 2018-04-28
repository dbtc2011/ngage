//
//  CustomModalView.swift
//  Ngage PH
//
//  Created by Mark Louie Angeles on 26/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

protocol CustomModalViewDelegate {
    func didTapOkayButton(tag: Int)
}
class CustomModalView: UIView {

    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonExtra: UIButton!
    @IBOutlet weak var extraWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonCenterConstraint: NSLayoutConstraint!
    
    
    var delegate : CustomModalViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> CustomModalView {
        return Bundle.main.loadNibNamed("CustomModalView",
                                        owner: nil,
                                        options: nil)?.first as! CustomModalView
    }

    func setupContent(value: String) {
        self.backgroundColor = UIColor.clear
        containerView.layer.cornerRadius = 10
        button.layer.cornerRadius = 5
        labelContent.text = value
        
        
        if buttonExtra.title(for: UIControlState.normal) == "" || buttonExtra.title(for: UIControlState.normal) == nil {
            buttonExtra.isHidden = true
            extraWidthConstraint.constant = 0
            buttonCenterConstraint.constant = 0
        }
    }
    
    //MARK: - Action
    @IBAction func buttonClicked(_ sender: UIButton) {
        delegate?.didTapOkayButton(tag: sender.tag)
    }
    
}
