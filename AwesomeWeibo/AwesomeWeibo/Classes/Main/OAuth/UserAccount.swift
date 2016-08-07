//
//  UserAccount.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/4/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    //MARK:- properties
    var access_token: String?
    var expires_in: NSTimeInterval = 0.0
    var uid: String?
    
    var expires_date: NSDate?
    
    //user info
    var screen_name: String?
    var avatar_large: String?
    
    //MARK:- init
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        expires_date = NSDate(timeIntervalSinceNow: expires_in)
    }
    
    //override setValue so that setValuesForKeysWithDictionary won't cause an error on extra dict keys
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    //MARK:- override desciption property for easy printing
    override var description: String {
        return dictionaryWithValuesForKeys(["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }
    
    
    //MARK:- for Archiver
    //解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
    
    //归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
}

