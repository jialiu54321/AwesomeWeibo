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
        
        visitorView.setVisitorViewInfo("VisitorView_Profile", tipLabelText: "Please login to get user profile. ")
    }

}
