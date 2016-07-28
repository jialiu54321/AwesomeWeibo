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
    private lazy var imageNames = ["tabBar_HomeIcon", "tabBar_MessageIcon", "", "tabBar_DiscoverIcon", "tabBar_ProfileIcon"];
    private lazy var composeBtn: UIButton = UIButton()
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addComposeBtn()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //viewWillAppear会覆盖viewDidLoad中有关tabBar.item的内容，所以对于tabBar.item的调整放在这里
        adjustItemsInTabBar()
    }
    
}


// MARK:- UI setting
extension MainViewController {
    /// add a compose btn
    private func addComposeBtn() {
        //添加+按钮
        tabBar.addSubview(composeBtn)
        //set btn image
        composeBtn.setBackgroundImage(UIImage(named: "tabBar_Compose_background"), forState: .Normal)
        composeBtn.setBackgroundImage(nil, forState: .Highlighted)
        composeBtn.setImage(UIImage(named: "tabBar_ComposeIcon"), forState: .Normal)
        composeBtn.setImage(UIImage(named: "tabBar_ComposeIcon_highlighted"), forState: .Highlighted)
        composeBtn.sizeToFit()
        //set btn position
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
    }
    
    /// adjust items in tabBar
    private func adjustItemsInTabBar() {
        //遍历tabBar中的所有item
        for i in 0..<tabBar.items!.count {
            let item = tabBar.items![i]
            if i == 2 {
                item.enabled = false
                continue
            }
            
            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
        }
    }
    
}
