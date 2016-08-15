//
//  PicPickerCollectionViewCell.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/10/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class PicPickerCollectionViewCell: UICollectionViewCell {
    
    //MARK:- UI objects
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- properties
    var image: UIImage? {
        didSet {
            if image != nil {
                addBtn.userInteractionEnabled = false
                imageView.image = image
                removeBtn.hidden = false
            } else {
                imageView.image = nil
                addBtn.userInteractionEnabled = true
                removeBtn.hidden = true
            }
        }
    }
    
    //MARK:- event listener
    @IBAction func addBtnClick(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerAddPhotoNote, object: nil)
    }
    
    @IBAction func removeBtnClick(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerRemovePhotoNote, object: imageView.image)
    }
}
