//
//  PicPickerCollectionView.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/10/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

private let edgeMargin: CGFloat = 10

class PicPickerCollectionView: UICollectionView {
    
    //MARK:- properties
    var images: [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    //MARK:- system callbacks
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.lightGrayColor()
        
        //set layout of UICollectionView
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (UIScreen.mainScreen().bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        //inner padding
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: edgeMargin, right: edgeMargin)
        
        //register cell, .self will return the class of UICollectionViewCell
        registerNib(UINib(nibName: "PicPickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "picPickerCell")
        
        dataSource = self
    }
    
}


//MARK:- data source
extension PicPickerCollectionView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picPickerCell", forIndexPath: indexPath) as! PicPickerCollectionViewCell
        
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
}
