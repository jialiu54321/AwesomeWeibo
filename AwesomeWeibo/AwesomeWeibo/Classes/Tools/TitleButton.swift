//
//  TitleButton.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/30/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "NavBar_TitleBtn_Down"), forState: .Normal)
        setImage(UIImage(named: "NavBar_TitleBtn_Up"), forState: .Selected)
        
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //adjust layout
    override func layoutSubviews() {
        super.layoutSubviews()
        //put label before image
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 3
    }
}
