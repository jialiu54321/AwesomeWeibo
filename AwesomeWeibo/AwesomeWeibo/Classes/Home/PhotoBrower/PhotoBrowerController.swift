//
//  PhotoBrowerController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/14/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import SDWebImage

private let PhotoBrowerCell = "PhotoBrowerCell"

class PhotoBrowerController: UIViewController {
    
    //MARK:- properties
    var indexPath: NSIndexPath
    var picUrls: [NSURL]
    
    //MARK:- lazy load variables
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowerCollectionViewLayout())
    private lazy var closeBtn: UIButton = UIButton(title: "Close", fontSize: 14, bgcolor: UIColor.lightGrayColor())
    private lazy var saveBtn: UIButton = UIButton(title: "Save", fontSize: 14, bgcolor: UIColor.lightGrayColor())
    
    //MARK:- init
    init(indexPath: NSIndexPath, picUrls: [NSURL]) {
        self.indexPath = indexPath
        self.picUrls = picUrls
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- system callbacks
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        //scroll to the right position
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
    
}

//MARK:- setup UI
extension PhotoBrowerController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        view.addSubview(closeBtn)
        
        //set up frame
        collectionView.frame = view.bounds
        closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(40)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 80, height: 32))
        }
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-60)
            make.bottom.equalTo(closeBtn.snp_bottom)
            make.size.equalTo(closeBtn.snp_size)
        }
        
        collectionView.registerClass(PhotoBrowerViewCell.self, forCellWithReuseIdentifier: PhotoBrowerCell)
        collectionView.dataSource = self
        
        //btn listeners
        closeBtn.addTarget(self, action: #selector(PhotoBrowerController.closeBtnClick), forControlEvents: .TouchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowerController.saveBtnClick), forControlEvents: .TouchUpInside)
    }
}

//MARK:- collectionView dataSource
extension PhotoBrowerController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowerCell, forIndexPath: indexPath) as! PhotoBrowerViewCell
        
        cell.picUrl = picUrls[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

//MARK:- event listeners
extension PhotoBrowerController {
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @objc private func saveBtnClick() {
        
        let cell = collectionView.visibleCells().first as! PhotoBrowerViewCell
        
        guard let image = cell.imageView.image else {
            return
        }
        
        //save image to album
        // Adds a photo to the saved photos album.  The optional completionSelector should have the form:
        //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowerController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var message = ""
        if error != nil {
            message = "Failed to save."
        } else {
            message = "Image saved."
        }
        
        SVProgressHUD.showInfoWithStatus(message)
    }
}

//MARK:- PhotoBrowerViewCellCellDelegate
extension PhotoBrowerController: PhotoBrowerViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}

//MARK:- PhotoBrowerAnimatorDismissedDelegate
extension PhotoBrowerController: PhotoBrowerAnimatorDismissedDelegate {
    func imageView() -> UIImageView {
        let cell = collectionView.visibleCells().first as! PhotoBrowerViewCell
        
        let imageView: UIImageView = UIImageView()
        imageView.image = cell.imageView.image
        imageView.frame = cell.imageView.frame
        
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    func indexPathForDismissedView() -> NSIndexPath {
        let cell = collectionView.visibleCells().first!
        return collectionView.indexPathForCell(cell)!
    }
}

//MARK:- customized layout
class PhotoBrowerCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = collectionView!.bounds.size
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        scrollDirection = .Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}

