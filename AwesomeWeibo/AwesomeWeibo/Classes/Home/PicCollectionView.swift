//
//  PicCollectionView.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/8/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {

    //MARK:- properties
    var picURLs: [NSURL] = [NSURL]() {
        didSet {
            self.reloadData()
        }
    }
    
    //MARK:- system callbacks
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
    }
    
}

extension PicCollectionView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PicCell", forIndexPath: indexPath) as! PicCollectionViewCell
        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
}


//customized cell
class PicCollectionViewCell: UICollectionViewCell {
    
    //MARK:- properties
    var picURL: NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            cellImageView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    //MARK:- UI objects
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    
}



