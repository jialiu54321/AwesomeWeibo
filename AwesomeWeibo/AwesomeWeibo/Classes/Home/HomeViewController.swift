//
//  HomeViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 7/28/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    //MARK:- lazy load
    private lazy var titleBtn: TitleButton = TitleButton()
    //[weak self] 解决循环引用
    private lazy var popOverAnimator: PopOverAnimator = PopOverAnimator {[weak self] (isPresented) -> () in
        self?.titleBtn.selected = isPresented
    }
    private lazy var tipLabel: UILabel = UILabel()  //uiview for the top lab showing "xx new tweets"
    
    private lazy var statusViewModels: [StatusViewModel] = [StatusViewModel]()
    
    private lazy var photoBrowerAnimator: PhotoBrowerAnimator = PhotoBrowerAnimator()
    
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addRotationAnim()
        
        if !isLogin {
            setupTitleStyle()
            return
        }
        
        setupNavBar()
        
        //set the estimated height of cell
        tableView.estimatedRowHeight = 200
        
        //setup header and footer for refreshing
        setupHeaderView()
        setupFooterView()
        
        //setup tip label
        setupTipLabel()
        
        //setup notification observer
        setupNotificationObservers()
    }
}

//MARK:- set up UI
extension HomeViewController {
    
    private func setupTitleStyle() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
    
    private func setupNavBar() {
        //set up navbar buttons
        let leftBtn = UIButton(imageName: "NavBar_ProfileIcon", width: 25, height: 25)
        let rightBtn = UIButton(imageName: "NavBar_ScanIcon", width: 25, height: 25)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        //set up navbar title menu
        titleBtn.setTitle(UserAccountViewModel.shareInstance.account?.screen_name ?? "", forState: .Normal)
        titleBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)//titleBtnClick有参数，所以要加冒号
        
        navigationItem.titleView = titleBtn
    }
    
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))
        
        header.setTitle("pull to refresh", forState: .Idle)
        header.setTitle("Release to refresh", forState: .Pulling)
        header.setTitle("Refreshing...", forState: .Refreshing)
        
        tableView.mj_header = header
        
        tableView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatuses))
    }
    
    private func setupTipLabel() {
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)   //tip label添加到父控件中
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.mainScreen().bounds.width, height: 30)
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.textAlignment = .Center
        tipLabel.hidden = true
    }
    
    private func setupNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.showPhotoBrower(_:)), name: ShowPhotoBrowerNote, object: nil)
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
    
    @objc private func showPhotoBrower(note: NSNotification) {
        
        let indexPath = note.userInfo![ShowPhotoBrowerIndexPathKey] as! NSIndexPath
        let picUrls = note.userInfo![ShowPhotoBrowerPicUrlsKey] as! [NSURL]
        let object = note.object as! PhotoBrowerAnimatorPresentedDelegate
            
        let photoBrowerVC = PhotoBrowerController(indexPath: indexPath, picUrls: picUrls)
        
        //set modalPresentationStyle to make sure that objects in current view is not hidden during presenting 
        photoBrowerVC.modalPresentationStyle = .Custom
        
        //customize transitioningDelegate
        photoBrowerVC.transitioningDelegate = photoBrowerAnimator
        
        photoBrowerAnimator.presentedDeletate = object 
        photoBrowerAnimator.indexPath = indexPath
        photoBrowerAnimator.dismissedDeletate = photoBrowerVC
        
        presentViewController(photoBrowerVC, animated: true, completion: nil)
    }
}

//MARK:- load home page info
extension HomeViewController {
    private func loadStatuses(isNewStatuses: Bool) {
        
        //get since_id and max_id
        var since_id = 0
        var max_id = 0
        if isNewStatuses {
            since_id = statusViewModels.first?.status?.mid ?? 0
        } else {
            max_id = statusViewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : max_id - 1
        }
        
        NetworkTools.shareInstance.loadStatuses(since_id, max_id: max_id, access_token: (UserAccountViewModel.shareInstance.account?.access_token)!) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let resultArray = result else {
                return
            }
            
            var tempStatusesViewModels: [StatusViewModel] = [StatusViewModel]()
            for statusDict in resultArray {
                tempStatusesViewModels.append(StatusViewModel(status: Status(dict: statusDict) ))
            }
            
            if isNewStatuses {
                self.statusViewModels =  tempStatusesViewModels + self.statusViewModels //put new data in front of the old data
            } else {
                self.statusViewModels =  self.statusViewModels + tempStatusesViewModels
            }
            
            //cache the image and then refresh the table view
            self.cacheImage(tempStatusesViewModels)
        }
    }
    
    private func cacheImage(statusViewModels: [StatusViewModel]) {
        
        //异步操作放在group中
        let group = dispatch_group_create()
        
        for statusViewModel in statusViewModels {
            for picURL in statusViewModel.picURLs {
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    dispatch_group_leave(group)
                })
            }
        }
        
        //refresh the table view
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.showTipLabel(statusViewModels.count)
        }
    }
    
    @objc private func loadNewStatuses() {
        loadStatuses(true)
    }
    
    @objc private func loadMoreStatuses() {
        loadStatuses(false)
    }
    
    private func showTipLabel(count: Int) {
        tipLabel.hidden = false
        tipLabel.text = count == 0 ? "No new tweets" : "\(count) new tweets"
        
        UIView.animateWithDuration(1.0, animations: { 
            self.tipLabel.frame.origin.y = self.navigationController?.navigationBar.frame.height ?? 44
            }) { (_) in
                UIView.animateWithDuration(1.0, delay: 1.0, options: [], animations: { 
                    self.tipLabel.frame.origin.y = 10
                    }, completion: { (_) in
                        self.tipLabel.hidden = true
                })
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let statusViewModel = statusViewModels[indexPath.row]
        return statusViewModel.cellHeight
    }
}