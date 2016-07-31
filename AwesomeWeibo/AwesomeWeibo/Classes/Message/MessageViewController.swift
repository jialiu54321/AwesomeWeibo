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
        
        visitorView.setVisitorViewInfo("VisitorView_Message", tipLabelText: "Please login to send and receice messages.")
    }
}
