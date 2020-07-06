//
//  CustomPresentModalAnimator.swift
//  CusomPresentViewController
//
//  Created by Exlinct on 11/26/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation
import UIKit

class CustomPresentModalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.4
    var presenting = true
    
    var xScaleFactor: CGFloat = 0.0
    var yScaleFactor: CGFloat = 0.0
    
    var originFrame = CGRect.zero
    var initialFrame = CGRect.zero
    var finalFrame = CGRect.zero
    
    private let AvatarImageViewTag = 69
    
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
	 func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        
		guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        // hide to viewcontroller
        toVC.view.layer.opacity = 0.0
        
		let containView = transitionContext.containerView
        
        // when present fromVC is CustomPresentModalViewController
        // when dismiss toVC is CustomPresentModalViewController
        let navigationControllerFirst = presenting ? (fromVC as! UINavigationController) : (toVC as! UINavigationController)
        let customPresentModalVC = navigationControllerFirst.viewControllers.last as! CustomPresentModalViewController
        
        // get avatar image view
		let topView = customPresentModalVC.view.subviews.compactMap{ $0 }.filter{ $0.tag == 68 }.first!
		let avatarImageViewFirst = topView.subviews.compactMap{ $0 }.filter{ $0.tag == AvatarImageViewTag }.first!
        
        // hide avatar image view
        avatarImageViewFirst.layer.opacity = 0.0
        
        // when present toVC is AvatarViewController
        // when dismiss fromVC is AvatarViewController
        let avatarViewController = presenting ? (toVC as! AvatarViewController) : (fromVC as! AvatarViewController)
        avatarViewController.view.layoutIfNeeded()
        avatarViewController.view.layoutSubviews()
		let avatarImageViewSecond = avatarViewController.view.subviews.compactMap{ $0 }.filter{ $0.tag == AvatarImageViewTag }.first!
        
        // hide avatar
        avatarImageViewSecond.layer.opacity = 0.0
        
        // make fake avatar image view for animation
        let fakeAvatarImageView = UIImageView(image: UIImage(named: "image.jpg"))
        
        // calculate frame fake avatar image view
        // when present it will move from top to center
        // when dismiss it will move from center to top
        if presenting {
            // when present init frame will be avatar image frame in CustomPresentModalViewController
            initialFrame = originFrame
            
            // when present final frame will be avatar image frame in AvatarViewController
            finalFrame = avatarImageViewSecond.frame
            
            // set fake avatar image frame
            fakeAvatarImageView.frame = initialFrame
            fakeAvatarImageView.setRounded()
        } else {
            // when dismiss init frame will be avatar image frame in AvatarViewController
            initialFrame = avatarImageViewSecond.frame
            
            // when dismiss final frame will be avatar image frame in CustomPresentModalViewController
            finalFrame = originFrame
            
            // set fake avatar image frame
            fakeAvatarImageView.frame = initialFrame
            fakeAvatarImageView.setRounded()
        }
        
        // set fake avatar image center
		fakeAvatarImageView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
    
        // calculate scale fake avatar image
        xScaleFactor = finalFrame.size.width / initialFrame.size.width
        yScaleFactor = finalFrame.size.height / initialFrame.size.height
        
		let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        // add fake avatar image view into toVC
        containView.addSubview(toVC.view)
        containView.addSubview(fakeAvatarImageView)
        containView.bringSubviewToFront(fakeAvatarImageView)
        
        // make animation for transition between controllers
		UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                   delay: 0,
                                   options: .curveEaseInOut,
                                   animations: {
                                    fakeAvatarImageView.transform = scaleTransform
									fakeAvatarImageView.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
                                    toVC.view.layer.opacity = 1.0
            }) { finished in
                // show avatar in both view controller
                avatarImageViewFirst.layer.opacity = 1.0
                avatarImageViewSecond.layer.opacity = 1.0
                
                // remove fake avatar iamge view
                fakeAvatarImageView.removeFromSuperview()
                
                // complete
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
