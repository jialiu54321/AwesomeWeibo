//
//  User.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/6/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    //MARK:- Properties
    var profile_image_url: String?
    var screen_name: String?
    var verified_type: Int = -1
    //user level
    var mbrank: Int = 0
    
    //MARK:- init
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    
}
