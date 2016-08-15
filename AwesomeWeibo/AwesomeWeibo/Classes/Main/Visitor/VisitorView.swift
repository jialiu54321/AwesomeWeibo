//
//  VisitorView.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/29/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    //MARK:- view objects
    @IBOutlet weak var rotatingWheel: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK:- public methods
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
    }
    
    func setVisitorViewInfo(iconViewImageName: String, tipLabelText: String) {
        iconView.image = UIImage(named: iconViewImageName)
        tipLabel.text = tipLabelText
        rotatingWheel.hidden = true;
    }
    
    func addRotationAnim() {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 10
        rotationAnim.removedOnCompletion = false
        rotatingWheel.layer.addAnimation(rotationAnim, forKey: nil)
    }
}
