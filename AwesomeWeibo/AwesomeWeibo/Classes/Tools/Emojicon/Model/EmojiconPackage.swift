//
//  EmojiconPackage.swift
//  emojiKeyboard
//
//  Created by Jia Liu on 8/11/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class EmojiconPackage: NSObject {

    var emojicons: [Emojicon] = [Emojicon]()
    
    init(id: String) {
        super.init()
        
        if id == "" {
            addEmptyEmojicons(true)
            return
        }
        
        let infoPlistPath = NSBundle.mainBundle().pathForResource("\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        
        let array = NSArray(contentsOfFile: infoPlistPath)! as! [[String: String]]
        
        var index = 0
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            
            emojicons.append(Emojicon(dict: dict))
            index += 1
            
            if index == 20 {
                //append a delete btn
                emojicons.append(Emojicon(isRemove: true))
                
                index = 0
            }
        }
        
        //add empty emojicons
        self.addEmptyEmojicons(false)
    }
    
    
    private func addEmptyEmojicons(forRecent: Bool) {
        
        //add empty emojicons
        let count = emojicons.count % 21
        if count == 0 && !forRecent {
            return
        }
    
        for _ in count..<20 {
            emojicons.append(Emojicon(isEmpty: true))
        }
        emojicons.append(Emojicon(isRemove: true))
    }
}
