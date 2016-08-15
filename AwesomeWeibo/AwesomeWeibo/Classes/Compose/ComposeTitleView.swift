//
//  ComposeTitleView.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/10/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {
    
    //MARK:- lazy load variables
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var screenNameLabel: UILabel = UILabel()
    
    //MARK:- init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- setup UI
extension ComposeTitleView {
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        //set frame
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        
        titleLabel.font = UIFont.systemFontOfSize(15)
        screenNameLabel.font = UIFont.systemFontOfSize(10)
        
        titleLabel.textColor = UIColor.whiteColor()
        screenNameLabel.textColor = UIColor.lightGrayColor()
        
        titleLabel.text = "Post New Tweets"
        screenNameLabel.text = UserAccountViewModel.shareInstance.account?.screen_name
    }
}
