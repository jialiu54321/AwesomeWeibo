//
//  EmojiconManager.swift
//  emojiKeyboard
//
//  Created by Jia Liu on 8/11/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import Foundation

class EmojiconManager {
    
    var packages: [EmojiconPackage] = [EmojiconPackage]()
    
    init() {
        //append recent EmojiconPackage
        packages.append(EmojiconPackage(id: ""))
        
        //append default EmojiconPackage
        packages.append(EmojiconPackage(id: "com.sina.default"))
        
        //append emoji EmojiconPackage
        packages.append(EmojiconPackage(id: "com.apple.emoji"))
        
        //append 浪小花 EmojiconPackage
        packages.append(EmojiconPackage(id: "com.sina.lxh"))
    }
}