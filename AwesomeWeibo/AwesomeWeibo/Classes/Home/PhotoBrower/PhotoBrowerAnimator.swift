//
//  PhotoBrowerAnimator.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/14/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class PhotoBrowerAnimator: NSObject {
    var isPresented: Bool = false
    
    var presentedDeletate: PhotoBrowerAnimatorPresentedDelegate?
    var dismissedDeletate: PhotoBrowerAnimatorDismissedDelegate?
    
    var indexPath: NSIndexPath?
}


//protocol oriented
//protocol for zoom in/out animation
protocol PhotoBrowerAnimatorPresentedDelegate: NSObjectProtocol {
    func startRect(indexPath: NSIndexPath) -> CGRect
    func endRect(indexPath: NSIndexPath) -> CGRect
    func imageView(indexPath: NSIndexPath) -> UIImageView
}
protocol PhotoBrowerAnimatorDismissedDelegate: NSObjectProtocol {
    func indexPathForDismissedView() -> NSIndexPath
    func imageView() -> UIImageView
}

//MARK:- UIViewControllerTransitioningDelegate
extension PhotoBrowerAnimator: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowerAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            animationForPresentedView(transitionContext)
        } else {
            animationForDismissedView(transitionContext)
        }
    }
    
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedDeletate = presentedDeletate, indexPath = indexPath else {
            return
        }
        
        
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        transitionContext.containerView()?.addSubview(presentedView)

        //animation for fading in/out
//        presentedView.alpha = 0
//        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
//            presentedView.alpha = 1
//        }) { (_) in
//            transitionContext.completeTransition(true)
//        }
        
        let startRect = presentedDeletate.startRect(indexPath)
        let endRect = presentedDeletate.endRect(indexPath)
        let imageView = presentedDeletate.imageView(indexPath)
        transitionContext.containerView()?.addSubview(imageView)
        imageView.frame = startRect
        
        //execute animation
        presentedView.alpha = 0
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
            imageView.frame = endRect
            }) { (_) in
                imageView.removeFromSuperview()
                presentedView.alpha = 1
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                transitionContext.completeTransition(true)
        }
        
    }
    
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let dismissedDeletate = dismissedDeletate, presentedDeletate = presentedDeletate else {
            return
        }
        
        let dismissedView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        dismissedView.removeFromSuperview()
        
        let imageView = dismissedDeletate.imageView()
        let indexPath = dismissedDeletate.indexPathForDismissedView()
        
        transitionContext.containerView()?.addSubview(imageView)
        
        //animation for fading in/out
//        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
//            dismissedView.alpha = 0
//        }) { (_) in
//            dismissedView.removeFromSuperview()
//            transitionContext.completeTransition(true)
//        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
            imageView.frame = presentedDeletate.startRect(indexPath)
            }) { (_) in
                imageView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}