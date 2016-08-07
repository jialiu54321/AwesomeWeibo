//
//  TitleMenuPresentationController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/31/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class TitleMenuPresentationController: UIPresentationController {
    
    //MARK:- public properties
    var presentedFrame: CGRect = CGRectZero
    
    //MARK:- lazy load
    lazy private var coverView: UIView = UIView()
    
    //MARK:- System call backs
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //change the size of frame
        presentedView()?.frame = presentedFrame
        
        //add a cover
        setupCoverView()
    }
}

//MARK:- UI set up
extension TitleMenuPresentationController {
    private func setupCoverView() {
        containerView?.insertSubview(coverView, atIndex: 0)//背景加到最下层
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        //add gesture
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(TitleMenuPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}


//MARK:- event lietener
extension TitleMenuPresentationController {
    @objc private func coverViewClick() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}