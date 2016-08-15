//
//  UserAccountTools.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/5/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    
    typealias SuccessCallBack = (isSuccess : Bool) -> ()
    
    //MARK:- singleton
    static let shareInstance: UserAccountViewModel = UserAccountViewModel()

    //MARK:- variables
    //sandbox path
    var accountPath: String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        print(accountPath)
        return (accountPath as NSString).stringByAppendingPathComponent("account.plist")
    }
    var account: UserAccount?
    
    init() {
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
    
    func isLogin() -> Bool {
        if account != nil  {
            if let expires_date = account?.expires_date {
                //if access_token expires
                return expires_date.compare(NSDate()) == NSComparisonResult.OrderedDescending
            } else {
                return false
            }
        }
        return false
    }
}

extension UserAccountViewModel {
    //get access_token
    func loadAccessToken(code: String, success: SuccessCallBack) {
        NetworkTools.shareInstance.getAccessToken(code) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let accountDict = result else {
                print("fail to get account data")
                return
            }
            
            let account = UserAccount(dict: accountDict)
            
            //get user info
            self.loadUserInfo(account, success: success)
        }
    }
    
    //get user info
    private func loadUserInfo(account: UserAccount, success: SuccessCallBack) {
        
        guard let accessToken = account.access_token else {
            return
        }
        guard let uid = account.uid else {
            return
        }
        
        NetworkTools.shareInstance.loadUserInfo(accessToken, uid: uid) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let userInfoDict = result else {
                return
            }
            
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            //save account object
            NSKeyedArchiver.archiveRootObject(account, toFile: self.accountPath)
            
            self.account = account
             
            success(isSuccess: true)
        }
    }
}
