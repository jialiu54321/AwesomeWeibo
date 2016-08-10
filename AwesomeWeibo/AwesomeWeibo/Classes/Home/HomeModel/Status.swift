//
//  Status.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/5/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    //MARK:- properties
    var created_at: String?
    var source: String?
    var text: String?
    var mid: Int = 0
    var pic_urls: [[String: String]]?
    
    var user: User?
    
    var retweeted_status: Status?           //retweeted weibo
    
    //MARK:- init
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        //set user
        if let userDict = dict["user"] as? [String: AnyObject] {
            user = User(dict: userDict)
        }
        
        //set retweeted_status
        if let retweeted_statusDict = dict["retweeted_status"] as? [String: AnyObject] {
            retweeted_status = Status(dict: retweeted_statusDict)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
