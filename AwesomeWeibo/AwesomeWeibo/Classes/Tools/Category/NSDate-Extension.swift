//
//  NSDate-Extension.swift
//  weibo时间处理
//
//  Created by Jia Liu on 8/6/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import Foundation

extension NSDate {
    
    class func creatDateString(creatAtStr: String) -> String {
        
        //get a NSDateFormatter
        let fmt = NSDateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en")
        
        //cast date to NSDate
        guard let creatDate = fmt.dateFromString(creatAtStr) else {
            return ""
        }
        
        //time interval from creatDate to nowDate
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSinceDate(creatDate))
        print(interval)
        
        if interval < 60 {
            return "Just Now"
        }
        
        if interval < 60 * 60 {
            return "\(interval / 60) Mins Ago"
        }
        
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60) ) Hours Ago"
        }
        
        let calender = NSCalendar.currentCalendar()
        
        if calender.isDateInYesterday(creatDate) {
            fmt.dateFormat = "Yesterday HH:mm"
            return fmt.stringFromDate(creatDate)
        }
        
        let cmps = calender.components(.Year, fromDate: creatDate, toDate: nowDate, options: [])
        if cmps.year < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            return fmt.stringFromDate(creatDate)
        } else {
            fmt.dateFormat = "yyyy-MM-dd HH:mm"
            return fmt.stringFromDate(creatDate)
        }
        
    }
    
}