//
//  FindEmojicon.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/13/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class FindEmojicon: NSObject {
    
    //MARK:- singleton
    static let sharedInstance: FindEmojicon = FindEmojicon()
    
    //MARK:- lazy load proerties
    private lazy var manager: EmojiconManager = EmojiconManager()
    
    func findAttrString(statusText: String?, font: UIFont) -> NSMutableAttributedString? {
        guard let statusText = statusText else {
            return nil
        }
        
        let pattern = "\\[.*?\\]" //pattern for normal emojis
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let results = regex.matchesInString(statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        let attrMStr = NSMutableAttributedString(string: statusText)
        for var i = results.count - 1; i >= 0; i -= 1 {
            let result = results[i]
            
            let chs = (statusText as NSString).substringWithRange(result.range)
            
            guard let pngPath = findPngPath(chs) else {
                continue
            }
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            attrMStr.replaceCharactersInRange(result.range, withAttributedString: attrImageStr)
        }
        
        return attrMStr
    }
    
    
    private func findPngPath(chs: String) -> String? {
        for package in manager.packages {
            for emojicon in package.emojicons {
                if emojicon.chs == chs {
                    return emojicon.pngPath
                }
            }
        }
        return nil
    }
}
