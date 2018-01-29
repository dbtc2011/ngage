//
//  AccomplishmentView.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 27/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit

private struct Constants {
    static let numberOfGlasses = 8
    static let lineWidth: CGFloat = 5.0
    static let arcWidth: CGFloat = 76
    static var halfOfLineWidth: CGFloat {
        return lineWidth / 2
    }
}

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
        let outlineColor: UIColor = UIColor.blue
        let counter = 5
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        //then calculate the arc for each single glass
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        //then multiply out by the actual glasses drunk
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        
        //2 - draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - Constants.halfOfLineWidth,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        //3 - draw the inner arc
        outlinePath.addArc(withCenter: center,
                           radius: bounds.width/2 - Constants.arcWidth + Constants.halfOfLineWidth,
                           startAngle: outlineEndAngle,
                           endAngle: startAngle,
                           clockwise: false)
        
        //4 - close the path
        outlinePath.close()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
    }
 

}
