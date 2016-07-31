//
//  HomeViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/28/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //MARK:- lazy load
    private lazy var titleBtn: TitleButton = TitleButton()
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addRotationAnim()
        
        if !isLogin {
            return
        }
        
        setupNavBar()
    }
}

//MARK:- set up UI
extension HomeViewController {
    private func setupNavBar() {
        //set up navbar buttons
        let leftBtn = UIButton(imageName: "NavBar_ProfileIcon", width: 25, height: 25)
        let rightBtn = UIButton(imageName: "NavBar_ScanIcon", width: 25, height: 25)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        //set up navbar title menu
        titleBtn.setTitle("coderwhy", forState: .Normal)
        
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: .TouchUpInside)//titleBtnClick有参数，所以要加冒号
        
        navigationItem.titleView = titleBtn
    }
}

//MARK:- event listeners
extension HomeViewController {
    @objc private func titleBtnClick(titleBtn: TitleButton) {
        titleBtn.selected = !titleBtn.selected
        
        //create a viewcontroller
        let popvc = PopOverViewController()
        //设置modal保证底下的view不被移除
        popvc.modalPresentationStyle = .Custom
        //pop the viewcontroller
        presentViewController(popvc, animated: true, completion: nil)
    }

}
