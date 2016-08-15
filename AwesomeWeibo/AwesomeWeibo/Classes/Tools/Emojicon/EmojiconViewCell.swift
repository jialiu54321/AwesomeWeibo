//
//  EmojiconViewCell.swift
//  emojiKeyboard
//
//  Created by Jia Liu on 8/11/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class EmojiconViewCell: UICollectionViewCell {
    
    //MARK:- lazy load variables
    private lazy var emojiBtn: UIButton = UIButton()
    
    //MARK:- properties
    var emojicon: Emojicon? {
        didSet {
            guard let emojicon = emojicon else {
                return
            }
            
            if emojicon.isRemove {
                emojiBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
                emojiBtn.setTitle("", forState: .Normal)
            } else {
                emojiBtn.setImage(UIImage(contentsOfFile: emojicon.pngPath ?? ""),  forState: .Normal)
                
                emojiBtn.setTitle(emojicon.emojiCode, forState: .Normal)
                emojiBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
            }
        }
    }
    
    //MARK:- init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK:- setup UI
extension EmojiconViewCell {
    private func setupUI() {
        contentView.addSubview(emojiBtn)
        
        //frame
        emojiBtn.frame = contentView.bounds
        
        emojiBtn.userInteractionEnabled = false
    }
}
