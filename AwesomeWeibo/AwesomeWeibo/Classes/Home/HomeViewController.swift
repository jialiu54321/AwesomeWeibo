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
    //[weak self] 解决循环引用
    private lazy var popOverAnimator: PopOverAnimator = PopOverAnimator {[weak self] (isPresented) -> () in
        self?.titleBtn.selected = isPresented
    }
    
    private lazy var statusViewModels: [StatusViewModel] = [StatusViewModel]()
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addRotationAnim()
        
        if !isLogin {
            return
        }
        
        setupNavBar()
        
        loadStatuses()
        
        //dynamically change the height of cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
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
        
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)//titleBtnClick有参数，所以要加冒号
        
        navigationItem.titleView = titleBtn
    }
}

//MARK:- event listeners
extension HomeViewController {
    @objc private func titleBtnClick(titleBtn: TitleButton) {
        
        //create a viewcontroller
        let popvc = PopOverViewController()
        //设置modal保证底下的view不被移除
        popvc.modalPresentationStyle = .Custom
        
        //设置转场代理
        popOverAnimator.presentedFrame = CGRect(x: 60, y: 50, width: 200, height: 200)
        popvc.transitioningDelegate = popOverAnimator
        
        //pop the viewcontroller
        presentViewController(popvc, animated: true, completion: nil)
    }
}

//MARK:- load home page info
extension HomeViewController {
    private func loadStatuses() {
        NetworkTools.shareInstance.loadStatuses((UserAccountViewModel.shareInstance.account?.access_token)!) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let resultArray = result else {
                return
            }
            
            for statusDict in resultArray {
                self.statusViewModels.append(StatusViewModel(status: Status(dict: statusDict) ))
            }
            
            //refresh the table view
            self.tableView.reloadData()
        }
    }
}

//MARK:- func of TableViewController
extension HomeViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusViewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create cell
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCellId") as! HomeViewCell
        
        //set data for cell
        let statusViewModel = statusViewModels[indexPath.row]
        cell.statusViewModel = statusViewModel
        
        return cell
    }
}