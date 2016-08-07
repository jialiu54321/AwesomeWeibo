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

class HomeViewCell: UITableViewCell {
    //MARK:- UI objects
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var screenNameLable: UILabel!
    @IBOutlet weak var membershipLevelImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var mainText: UILabel!
    
    //MARK:- constrains
    @IBOutlet weak var mainTextWidthCons: NSLayoutConstraint!
    
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
            sourceLabel.text = statusViewModel.sourceText
            mainText.text = statusViewModel.status?.text
            //set color of screenNameLable depending on whether the user is a member
            screenNameLable.textColor = statusViewModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
        }
    }
    
    //MARK:- system callbacks
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //set the width of the weibo main content
        mainTextWidthCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
}
