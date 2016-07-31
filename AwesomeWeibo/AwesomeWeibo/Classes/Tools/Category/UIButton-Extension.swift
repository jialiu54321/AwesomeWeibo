//
//  UIButton-Extension.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/28/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit


extension UIButton {
//    //类方法是以class开头的方法。类似OC中+方法
//    class func creatButton(imageName: String, bgImageName: String) -> UIButton {
//        
//        let btn = UIButton()
//        //set btn image
//        btn.setImage(UIImage(named: imageName), forState: .Normal)
//        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
//        btn.setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
//        btn.setBackgroundImage(nil, forState: .Highlighted)
//        btn.sizeToFit()
//        
//        return btn
//    }
    
    //重写init，convenience修饰的叫便利构造函数，用于对系统类的构造函数进行扩充
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        
        //set btn image
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(nil, forState: .Highlighted)
        sizeToFit()
    }
    
    convenience init(imageName: String, width: CGFloat, height: CGFloat) {
        self.init()
        
        setImage(UIImage(named: imageName), forState: .Normal)
        //setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: height)
    }
    
    
    
}