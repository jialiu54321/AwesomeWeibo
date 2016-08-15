//
//  MainViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/27/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    //MARK:- lazy load varials
    private lazy var composeBtn: UIButton = UIButton(imageName: "tabBar_ComposeIcon", bgImageName: "tabBar_Compose_background")
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addComposeBtn() 
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        //viewWillAppear会覆盖viewDidLoad中有关tabBar.item的内容，所以对于tabBar.item的调整放在这里
//        adjustItemsInTabBar()
    }
    
}


// MARK:- UI setting
extension MainViewController {
    /// add a compose btn
    private func addComposeBtn() {
        //添加+按钮
        tabBar.addSubview(composeBtn)

        //set btn position
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
        
        //add listener
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), forControlEvents: .TouchUpInside)
    }
    
//    /// adjust items in tabBar
//    private func adjustItemsInTabBar() {
//        //遍历tabBar中的所有item
//        for i in 0..<tabBar.items!.count {
//            let item = tabBar.items![i]
//            if i == 2 {
//                item.enabled = false
//                continue
//            }
//            
//            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
//        }
//    }
    
}


// MARK:- events listener
extension MainViewController {
    @objc private func composeBtnClick() {
        let composeVC = ComposeViewController()
        let composeNav = UINavigationController(rootViewController: composeVC)
        presentViewController(composeNav, animated: true, completion: nil)
    }
}