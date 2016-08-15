//
//  AppDelegate.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/27/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var defaultViewController: UIViewController? {
        let isLogin = UserAccountViewModel.shareInstance.isLogin()
        return isLogin ? WelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
    
    func newScreen() {
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Color setting
        UITabBar.appearance().tintColor = UIColor(colorLiteralRed: 157/255.0, green: 244/255.0, blue: 173/255.0, alpha: 1)
        UITabBar.appearance().barTintColor = UIColor(colorLiteralRed: 84/255.0, green: 121/255.0, blue: 128/255.0, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(colorLiteralRed: 157/255.0, green: 244/255.0, blue: 173/255.0, alpha: 0.5)
        UINavigationBar.appearance().barTintColor = UIColor(colorLiteralRed: 84/255.0, green: 121/255.0, blue: 128/255.0, alpha: 0.5)
        
        //create the main interface
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

