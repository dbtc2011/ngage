//
//  AccomplishmentView.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

class AccomplishmentView: UIView {
    
    private var mainColor : UIColor = UIColor.yellow
    private var percentage : Int = 0
    private var labelPercentage : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        labelPercentage = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        labelPercentage.backgroundColor = UIColor.clear
        labelPercentage.text = "\(percentage)%"
        labelPercentage.textColor = UIColor.white
        self.addSubview(labelPercentage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMainColor(color : UIColor) {
        mainColor = color
    }
    
    func setPercentage(percent: Int) {
        percentage = percent
        labelPercentage.text = "\(percentage)%"
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
 

}
