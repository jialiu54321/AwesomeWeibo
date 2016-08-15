//
//  ProgessView.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/14/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class ProgessView: UIView {
    
    //MARK:- properties
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let radius = rect.size.width / 2 - 3
        let startAngle = CGFloat(-M_PI_2) //-pi/2
        let endAngle = CGFloat(M_PI * 2) * progress + startAngle
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.addLineToPoint(center)
        path.closePath()
        
        UIColor(white: 1, alpha: 0.3).setFill()
        
        path.fill()
    }
    
}
