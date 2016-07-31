//
//  BaseViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/29/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    //MARK:- lazy load variables
    lazy var visitorView: VisitorView = VisitorView.visitorView();
    
    //MARK:- variables
    var isLogin: Bool = true
    
    //MARK:- system callbacks
    override func loadView() {
        isLogin ? super.loadView() : setUpVisitorView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
    }
    
}

//MARK:- set up UI
extension BaseViewController {
    private func setUpVisitorView() {
        self.view = visitorView
        
        visitorView.loginBtn.addTarget(self, action: "loginBtnClick", forControlEvents: .TouchUpInside)
        visitorView.registerBtn.addTarget(self, action: "registerBtnClick", forControlEvents: .TouchUpInside)
        
    }
    
    private func setupNavigationItem() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .Plain, target: self, action: "registerBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .Plain, target: self, action: "loginBtnClick")
    }
}


//MARK:- event listener
extension BaseViewController {

    @objc private func registerBtnClick() {
        print("registerBtnClick")
    }
    @objc private func loginBtnClick() {
        print("loginBtnClick")
    }

}