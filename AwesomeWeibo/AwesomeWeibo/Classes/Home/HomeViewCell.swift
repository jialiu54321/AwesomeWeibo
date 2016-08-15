//
//  HomeViewCell.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/7/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin: CGFloat = 15
private let gapBetweenPics: CGFloat = 10

class HomeViewCell: UITableViewCell {
    //MARK:- UI objects
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var screenNameLable: UILabel!
    @IBOutlet weak var membershipLevelImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var imageCollectionView: PicCollectionView!
    @IBOutlet weak var retweetContent: UILabel!
    @IBOutlet weak var retweetBackground: UIView!
    @IBOutlet weak var bottomToolBar: UIView!
    
    //MARK:- constrains
    @IBOutlet weak var mainTextWidthCons: NSLayoutConstraint!
    @IBOutlet weak var ImageCollectionViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var ImageCollectionViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var ImageCollectionViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetContentTopCons: NSLayoutConstraint!
    
    //MARK:- properties
    var statusViewModel: StatusViewModel? {
        didSet {
            guard let statusViewModel = statusViewModel else {
                return
            }
            
            //set UI objects
            avatarImageView.sd_setImageWithURL(statusViewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            vipImageView.image = statusViewModel.verifiedImage
            screenNameLable.text = statusViewModel.status?.user?.screen_name
            membershipLevelImageView.image = statusViewModel.vipImage
            timeLabel.text = statusViewModel.createAtText
            sourceLabel.text = statusViewModel.sourceText != nil ? "From \(statusViewModel.sourceText!)" : ""
            
            mainText.attributedText = FindEmojicon.sharedInstance.findAttrString(statusViewModel.status?.text, font: mainText.font)
            
            //set color of screenNameLable depending on whether the user is a member
            screenNameLable.textColor = statusViewModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
            
            //set the size of ImageCollectionView
            let imageCollectionViewSize = calculateImageCollectionViewSize(statusViewModel.picURLs.count)
            ImageCollectionViewWidthCons.constant = imageCollectionViewSize.width
            ImageCollectionViewHeightCons.constant = imageCollectionViewSize.height
            
            //send picURLs to imageCollectionView
            imageCollectionView.picURLs = statusViewModel.picURLs
            
            //set retweetContent
            if statusViewModel.status?.retweeted_status != nil {
                if let screen_name = statusViewModel.status?.retweeted_status?.user?.screen_name, retweeted_text = statusViewModel.status?.retweeted_status?.text {
                    
                    let retweetText = "@\(screen_name): \(retweeted_text)"
                    retweetContent.attributedText = FindEmojicon.sharedInstance.findAttrString(retweetText, font: retweetContent.font)
                    
                    retweetContentTopCons.constant = 15
                }
                retweetBackground.hidden = false
            } else {
                retweetContent.text = nil
                retweetBackground.hidden = true
                retweetContentTopCons.constant = 0
            }
            
            //calculate the height of cell
            if statusViewModel.cellHeight == 0 {
                layoutIfNeeded()    //强制布局
                statusViewModel.cellHeight = CGRectGetMaxY(bottomToolBar.frame)    //get the maximum y of bottomToolBar
            }
        }
    }
    
    //MARK:- system callbacks
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //set the width of the weibo main content
        mainTextWidthCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
}

//calculation funcs
extension HomeViewCell {
    private func calculateImageCollectionViewSize(count: Int) -> CGSize {
        //no pic
        if count == 0 {
            ImageCollectionViewBottomCons.constant = 0
            return CGSizeZero
        }
        
        ImageCollectionViewBottomCons.constant = 10
        
        //get layout
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //one pic - get downloaded pic to use it's size info
        if count == 1 {
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(statusViewModel?.picURLs.first?.absoluteString)
            //return image.size
            layout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
        }
        
        //get imageView Width
        let imageViewWidth = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * gapBetweenPics) / 3
        
        //set layout.itemSize for all other situation except for only one pic
        layout.itemSize = CGSize(width: imageViewWidth, height: imageViewWidth)
        
        //4 pics
        if count == 4 {
            let imageCollectionViewWidth = imageViewWidth * 2 + gapBetweenPics + 1
            return CGSize(width: imageCollectionViewWidth, height: imageCollectionViewWidth)
        }
        
        //other pic counts
        let rows = CGFloat((count - 1) / 3 + 1)
        let imageCollectionViewHeight = rows * imageViewWidth + (rows - 1) * gapBetweenPics
        let imageCollectionViewWidth = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        return CGSize(width: imageCollectionViewWidth, height: imageCollectionViewHeight)
    }
}









