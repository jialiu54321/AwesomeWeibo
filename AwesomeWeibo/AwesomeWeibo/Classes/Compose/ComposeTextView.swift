//
//  ComposeTextView.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/10/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    
    //MARK:- lazy load variables
    lazy var placeHolderLabel: UILabel = UILabel()
    
    //MARK:- init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
}

//MARK:- setup UI
extension ComposeTextView {
    private func setupUI() {
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
        }
        
        placeHolderLabel.textColor = UIColor.lightGrayColor()
        placeHolderLabel.font = font
        
        placeHolderLabel.text = "Please enter content here..."
        
        //inner pading of text view
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}