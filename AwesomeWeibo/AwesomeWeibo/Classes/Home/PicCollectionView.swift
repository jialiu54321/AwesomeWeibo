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
        delegate = self
    }
    
}

extension PicCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK:- DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PicCell", forIndexPath: indexPath) as! PicCollectionViewCell
        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    //MARK:- delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.item)
        
        let userInfo = [ShowPhotoBrowerIndexPathKey: indexPath, ShowPhotoBrowerPicUrlsKey: picURLs]
        
        NSNotificationCenter.defaultCenter().postNotificationName(ShowPhotoBrowerNote, object: self, userInfo: userInfo)
    }
}


//MARK:- PhotoBrowerAnimatorPresentedDelegate
extension PicCollectionView: PhotoBrowerAnimatorPresentedDelegate {
    func startRect(indexPath: NSIndexPath) -> CGRect {
        let cell = self.cellForItemAtIndexPath(indexPath)!
        
        //get the cell's frame relative to the screen
        return self.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        let picUrl = picURLs[indexPath.item]
        
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrl.absoluteString)

        let width = UIScreen.mainScreen().bounds.width
        let height = width * image.size.height / image.size.width
        let y: CGFloat
        if height >= UIScreen.mainScreen().bounds.height {
            y = 0
        } else {
            y = (UIScreen.mainScreen().bounds.height - height) / 2
        }
        
        return CGRect(x: 0, y: y, width: width, height: height)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        let imageView: UIImageView = UIImageView()
        
        let picUrl = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrl.absoluteString)
        imageView.image = image
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}


//MARK:- customized cell
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



