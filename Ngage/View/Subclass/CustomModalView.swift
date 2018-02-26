//
//  CustomModalView.swift
//  Ngage PH
//
//  Created by Mark Louie Angeles on 26/02/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

protocol CustomModalViewDelegate {
    func didTapOkayButton()
}
class CustomModalView: UIView {

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
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(value: String) {
        containerView.layer.cornerRadius = 20
        labelContent.text = value
    }
    
    //MARK: - Action
    @IBAction func buttonClicked(_ sender: UIButton) {
        delegate?.didTapOkayButton()
    }
    
}
