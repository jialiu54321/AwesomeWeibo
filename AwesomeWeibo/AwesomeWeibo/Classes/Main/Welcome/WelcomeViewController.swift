//
//  WelcomeViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/5/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    //MARK:- UI objects
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileUrlString = UserAccountViewModel.shareInstance.account?.avatar_large
        print("WelcomeViewController \(UserAccountViewModel.shareInstance.account)")
        let profileUrl = NSURL(string: profileUrlString ?? "")
        iconView.sd_setImageWithURL(profileUrl, placeholderImage: UIImage(named: "avatar_default_big"))
        
        //change the constraint
        iconViewBottomCons.constant = UIScreen.mainScreen().bounds.height - 250
        //execute animation
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                //swich view after the animation
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        }
    }
}
