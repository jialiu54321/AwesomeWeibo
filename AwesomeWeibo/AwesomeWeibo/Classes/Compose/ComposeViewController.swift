//
//  ComposeViewController.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/10/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    
    //MARK:- ui objects
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    
    //MARK:- ui constrains
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHeightCons: NSLayoutConstraint!
    
    //MARK:- lazy load variables
    private lazy var titleView: ComposeTitleView = ComposeTitleView()
    private lazy var images: [UIImage] = [UIImage]()
    private lazy var emojiconVC: EmojiconViewController = EmojiconViewController {[weak self] (emojicon) in
        self?.textView.insertEmojicon(emojicon)
        self?.textViewDidChange(self!.textView)
    }
    
    //MARK:- system callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupNotifications()
    }
    
    //auto focus on the text view
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

//MARK:- ui setup
extension ComposeViewController {
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(ComposeViewController.closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .Plain, target: self, action: #selector(ComposeViewController.composeBtnClick))
        
        navigationItem.rightBarButtonItem?.enabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    private func setupNotifications() {
        //listen to the change of keyboards
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.addPicBtnClick), name: PicPickerAddPhotoNote, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.removePicBtnClick(_:)), name: PicPickerRemovePhotoNote, object: nil)
    }
}

//MARK:- event listener
extension ComposeViewController {
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func composeBtnClick() {
        
        textView.resignFirstResponder()
        
        let statusText = textView.getEmojiconString()
        
        let finishedCallback = { (isSucess: Bool) in
            if !isSucess {
                SVProgressHUD.showErrorWithStatus("Failed")
                return
            }
            
            SVProgressHUD.showSuccessWithStatus("Successfully Posted!")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if let image = images.first {
            NetworkTools.shareInstance.sendStatus((UserAccountViewModel.shareInstance.account?.access_token)!, statusText: statusText, image: image, isSucess: finishedCallback)
        } else {
            NetworkTools.shareInstance.sendStatus((UserAccountViewModel.shareInstance.account?.access_token)!, statusText: statusText, isSucess: finishedCallback)
        }
        
        NetworkTools.shareInstance.sendStatus((UserAccountViewModel.shareInstance.account?.access_token)!, statusText: statusText) { (isSucess) in
            if !isSucess {
                SVProgressHUD.showErrorWithStatus("Failed")
                return
            }
            
            SVProgressHUD.showSuccessWithStatus("Successfully Posted!")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @objc private func keyboardWillChangeFrame(note: NSNotification) {
        //get animation duration
        let duration = note.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSTimeInterval
        //get y value of keyboard
        let endY = (note.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).CGRectValue().origin.y
        
        //get the margin between bottom of screen and the tool bar
        let margin = UIScreen.mainScreen().bounds.height - endY
        
        toolbarBottomCons.constant = margin
        UIView.animateWithDuration(duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick(sender: AnyObject) {
        
        textView.resignFirstResponder()
        
        picPickerViewHeightCons.constant = UIScreen.mainScreen().bounds.height * 0.3
        UIView.animateWithDuration(0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func emojiKeyboardBtnClick(sender: AnyObject) {
        textView.resignFirstResponder()
        textView.inputView = textView.inputView != nil ? nil : emojiconVC.view
        textView.becomeFirstResponder()
    }
    
}

//MARK:- event listener for adding and deleting pic
extension ComposeViewController {
    @objc private func addPicBtnClick() {
        //if pic source is available
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        
        let ipc = UIImagePickerController()
        
        ipc.sourceType = .PhotoLibrary
        
        ipc.delegate = self
        
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    @objc private func removePicBtnClick(note: NSNotification) {
        guard let image = note.object as? UIImage else {
            return
        }
        guard let index = images.indexOf(image) else {
            return
        }
        images.removeAtIndex(index)
        
        picPickerView.images = images
        
    }
}

//MARK:- delegate for UIImagePickerControllerDelegate
extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        images.append(image)
        
        picPickerView.images = images
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}


//MARK:- UITextView delegate
extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}