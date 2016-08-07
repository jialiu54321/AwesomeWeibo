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
    
    var user: User?
    
    //MARK:- init
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        if let userDict = dict["user"] as? [String: AnyObject] {
            user = User(dict: userDict)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
