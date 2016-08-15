//
//  DiscoverViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/28/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView.setVisitorViewInfo("VisitorView_Discover", tipLabelText: "Please login to receive more info. ")
        }

        setupNavBar()
    }
}

//MARK:- set up UI
extension DiscoverViewController {
    private func setupNavBar() {
        //set up navbar buttons
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
}