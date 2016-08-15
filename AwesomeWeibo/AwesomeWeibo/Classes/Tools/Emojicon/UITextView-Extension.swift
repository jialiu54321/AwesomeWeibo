//
//  UITextView-Extension.swift
//  emojiKeyboard
//
//  Created by Jia Liu on 8/12/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

extension UITextView {
    func insertEmojicon(emojicon: Emojicon) {
        if emojicon.isEmpty {
            return
        }
        
        if emojicon.isRemove {
            deleteBackward()
            return
        }
        
        if emojicon.emojiCode != nil {
            let textRange = selectedTextRange!
            
            replaceRange(textRange, withText: emojicon.emojiCode!)
            
            return
        }
        
        //normal emojicon 图文混排
        let attachment = EmojiconAttachment()
        attachment.image = UIImage(contentsOfFile: emojicon.pngPath!)
        attachment.chs = emojicon.chs
        let font = self.font
        attachment.bounds = CGRect(x: 0, y: -4, width: font!.lineHeight, height: font!.lineHeight)
        
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = selectedRange
        attrMStr.replaceCharactersInRange(range, withAttributedString: attrImageStr)
        
        attributedText = attrMStr
        
        self.font = font
        
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
    
    func getEmojiconString() -> String {
        let attMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attMStr.length)
        attMStr.enumerateAttributesInRange(range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmojiconAttachment {
                attMStr.replaceCharactersInRange(range, withString: attachment.chs!)
            }
        }
        
        return attMStr.string
    }
}
