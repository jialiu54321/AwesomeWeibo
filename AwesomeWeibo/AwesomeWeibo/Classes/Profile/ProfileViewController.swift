//
//  ProfileViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/28/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: BaseViewController {
    
    //MARK:- lazy load variables
    private lazy var avatarImageView: UIImageView = UIImageView()
    private lazy var signOutBtn: UIButton = UIButton()
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            setupTitleStyle()
            visitorView.setVisitorViewInfo("VisitorView_Profile", tipLabelText: "Please login to get user profile. ")
            return
        }

        setupNavBar()
        setupTitleStyle()
    }
}

//MARK:- set up UI
extension ProfileViewController {
    
    private func setupTitleStyle() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
    
    private func setupNavBar() {
        //set up navbar buttons
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        //disable tableView
        tableView.separatorStyle = .None
        tableView.scrollEnabled = false
        
        //set avatarImageView
        tableView.addSubview(avatarImageView)
        avatarImageView.frame = CGRect(x: UIScreen.mainScreen().bounds.width / 2 - 45, y: 50, width: 90, height: 90)
        
        let profileUrlString = UserAccountViewModel.shareInstance.account?.avatar_large
        let profileUrl = NSURL(string: profileUrlString ?? "")
        avatarImageView.sd_setImageWithURL(profileUrl, placeholderImage: UIImage(named: "avatar_default_big"))
        avatarImageView.layer.cornerRadius = 45
        avatarImageView.layer.masksToBounds = true
        
        //set signOutBtn
        tableView.addSubview(signOutBtn)
        signOutBtn.setTitle("Sign Out", forState: .Normal)
        signOutBtn.backgroundColor = UIColor.redColor()
        signOutBtn.frame = CGRect(x: UIScreen.mainScreen().bounds.width / 2 - 75, y: 200, width: 150, height: 32)
        signOutBtn.addTarget(self, action: #selector(ProfileViewController.signOutBtnClick), forControlEvents: .TouchUpInside)
    }
}

//MARK:- event listener
extension ProfileViewController {
    @objc private func signOutBtnClick() {
        
        try? NSFileManager.defaultManager().removeItemAtPath(UserAccountViewModel.shareInstance.accountPath)
        
        UserAccountViewModel.shareInstance = UserAccountViewModel()
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).newScreen()
    }
}
