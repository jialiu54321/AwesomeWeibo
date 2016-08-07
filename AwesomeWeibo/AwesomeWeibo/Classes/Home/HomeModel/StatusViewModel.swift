//
//  StatusViewModel.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/6/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    //MARK:- properties
    var status: Status?
    
    //MARK:- processed properties
    var sourceText: String?
    var createAtText: String?
    
    var verifiedImage: UIImage?
    var vipImage: UIImage?
    
    var profileURL: NSURL?
    
    //MARK:- init
    init(status: Status) {
        self.status = status
        
        //get sourceText
        if let source = status.source where source != "" {
            //"source":"<a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>"
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</a>").location - startIndex
            sourceText = (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        }
        
        //get createAtText
        if let created_at = status.created_at {
            createAtText = NSDate.creatDateString(created_at)
        }
        
        //get verifiedImage
        let verified_type = status.user?.verified_type ?? -1
        switch verified_type {
        case 0: verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5: verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220: verifiedImage = UIImage(named: "avatar_grassroot")
        default: verifiedImage = nil
        }
        
        //get vipImage
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        //get profileURL
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = NSURL(string: profileURLString)
    }
    
    
}


