//
//  Emojicon.swift
//  emojiKeyboard
//
//  Created by Jia Liu on 8/11/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class Emojicon: NSObject {
    
    //MARK:- properties
    var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            
            let scanner = NSScanner(string: code)
            var value: UInt32 = 0
            scanner.scanHexInt(&value)
            
            let c = Character(UnicodeScalar(value))
            
            emojiCode = String(c)
        }
    }
    var png: String? {
        didSet {
            guard let png = png else {
                return
            }
            
            pngPath = NSBundle.mainBundle().bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs: String?
    
    //MARK:- processed properties
    var pngPath: String?
    var emojiCode: String?
    var isRemove: Bool = false
    var isEmpty: Bool = false
    
    //MARK:- init
    init(dict: [String: String]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    override var description: String {
        return dictionaryWithValuesForKeys(["emojiCode", "pngPath", "chs"]).description
    }
    
    init(isRemove: Bool) {
        self.isRemove = isRemove
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
}
