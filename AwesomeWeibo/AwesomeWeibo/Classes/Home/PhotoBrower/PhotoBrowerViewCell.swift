//
//  PhotoBrowerViewCell.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/14/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowerViewCellDelegate: NSObjectProtocol {
    func imageViewClick()
}

class PhotoBrowerViewCell: UICollectionViewCell {
    
    //MARK:- lazy load variables
    private lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    private lazy var progessView: ProgessView = ProgessView()
    
    //MARK:- properties
    var picUrl: NSURL? {
        didSet {
            setupContent(picUrl)
        }
    }
    var delegate: PhotoBrowerViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- setupUI
extension PhotoBrowerViewCell {
    private func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(progessView)
        scrollView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        
        progessView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progessView.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height / 2)
        
        progessView.hidden = true
        progessView.backgroundColor = UIColor.clearColor()
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowerViewCell.imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.userInteractionEnabled = true
    }
    
    private func setupContent(picUrl: NSURL?) {
        guard let picUrl = picUrl else {
            return
        }
        
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrl.absoluteString)
        
        //calculate the frame of imageView based on width/heigh ratio of image
        let x: CGFloat = 0
        let width = UIScreen.mainScreen().bounds.width
        let height = image.size.height * width / image.size.width
        var y: CGFloat = 0
        if height < UIScreen.mainScreen().bounds.height  {
            y = (UIScreen.mainScreen().bounds.height - height) / 2
        }
        
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        progessView.hidden = false
        imageView.sd_setImageWithURL(getMiddleURL(picUrl), placeholderImage: image , options: [], progress: { (current, total) in
            self.progessView.progress = CGFloat(current) / CGFloat(total)
            }) { (_, _, _, _) in
                self.progessView.hidden = true
        }
        
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    private func getMiddleURL(smallURL: NSURL) -> NSURL {
        let smallUrlStr = smallURL.absoluteString
        let middleUrlStr = smallUrlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        return NSURL(string: middleUrlStr)!
    }
}


//MARK:- event listener
extension PhotoBrowerViewCell {
    @objc private func imageViewClick() {
        delegate?.imageViewClick()
    }
}