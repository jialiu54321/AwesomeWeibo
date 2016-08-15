//
//  MessageViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/28/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView.setVisitorViewInfo("VisitorView_Message", tipLabelText: "Please login to send and receice messages.")
        }
        
        setupNavBar()
        
    }
}

//MARK:- set up UI
extension MessageViewController {
    private func setupNavBar() {
        //set up navbar buttons
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
    
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
}