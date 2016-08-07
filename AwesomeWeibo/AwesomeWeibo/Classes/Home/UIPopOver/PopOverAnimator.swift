//
//  PopoverAnimator.swift
//  AwesomeWeibo
//
//  Created by Jia Liu on 8/2/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import UIKit

class PopOverAnimator: NSObject {
    
    //MARK:- public properties
    var presentedFrame: CGRect = CGRectZero
    
    var callBack: ((isPresented: Bool) -> ())?
    
    //MARK:- properties
    private var isPresented: Bool = false
    
    //MARK:- init
    init(callBack: (isPresented: Bool) -> ()) {
        self.callBack = callBack
    }
}


extension PopOverAnimator: UIViewControllerTransitioningDelegate {
    
    //change the size of pop view
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        var titleMenuPresentationController = TitleMenuPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        titleMenuPresentationController.presentedFrame = presentedFrame
        
        return titleMenuPresentationController
    }
    
    //customize the animation
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented: isPresented)
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented: isPresented)
        return self
    }
}


extension PopOverAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentingView(transitionContext) : animationForDismissingView(transitionContext)
    }
    
    //弹出动画
    private func animationForPresentingView(transitionContext: UIViewControllerContextTransitioning) {
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        transitionContext.containerView()?.addSubview(presentedView)
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
            presentedView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                transitionContext.completeTransition(true)//通知动画已经完成
        }
    }
    
    //消失动画
    private func animationForDismissingView(transitionContext: UIViewControllerContextTransitioning) {
        let dismissedView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
            dismissedView.transform = CGAffineTransformMakeScale(1.0, 0.000000001)
            }) { (_) -> Void in
                dismissedView.removeFromSuperview()
                transitionContext.completeTransition(true)//通知动画已经完成
        }
    }
}
