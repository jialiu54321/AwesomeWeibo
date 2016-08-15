//
//  ProfileViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/28/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView.setVisitorViewInfo("VisitorView_Profile", tipLabelText: "Please login to get user profile. ")
        }

        setupNavBar()
        
        //test 123
        
    }
}

//MARK:- set up UI
extension ProfileViewController {
    private func setupNavBar() {
        //set up navbar buttons
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
}
