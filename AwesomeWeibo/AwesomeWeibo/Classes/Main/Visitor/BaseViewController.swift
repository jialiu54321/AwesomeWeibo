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
    var isLogin: Bool = UserAccountViewModel.shareInstance.isLogin()
    
    //MARK:- system callbacks
    override func loadView() {
        
        //choose which view to show
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
        
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), forControlEvents: .TouchUpInside)
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), forControlEvents: .TouchUpInside)
        
    }
    
    private func setupNavigationItem() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .Plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .Plain, target: self, action: #selector(BaseViewController.loginBtnClick))
    }
}


//MARK:- event listener
extension BaseViewController {

    @objc private func registerBtnClick() {
        print("registerBtnClick")
    }
    @objc private func loginBtnClick() {
        print("loginBtnClick")
        
        let oauthVc = OAuthViewController()
        //包装一个导航控制器
        //let oauthNav = UINavigationController(rootViewController: oauthVc)
        presentViewController(oauthVc, animated: true, completion: nil)
    }

}