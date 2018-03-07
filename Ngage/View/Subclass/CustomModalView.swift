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

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelContent: UILabel!
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
    }
    
    //MARK: - Action
    @IBAction func buttonClicked(_ sender: UIButton) {
        delegate?.didTapOkayButton(tag: 1)
    }
    
}