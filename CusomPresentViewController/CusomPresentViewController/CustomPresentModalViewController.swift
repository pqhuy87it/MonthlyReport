//
//  CustomPresentModalViewController.swift
//  CusomPresentViewController
//
//  Created by Exlinct on 11/26/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import UIKit

class CustomPresentModalViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.setRounded()
        }
    }
    
    let transition = CustomPresentModalAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    @IBAction func buttonPressed(sender: AnyObject) {
		let storybaord = UIStoryboard(name: "Main", bundle: nil)
		let avatarViewController = storybaord.instantiateViewController(withIdentifier: "avatarViewControllere") as! AvatarViewController
        avatarViewController.transitioningDelegate = self
		avatarViewController.modalPresentationStyle = .currentContext
		self.present(avatarViewController, animated: true, completion: nil)
    }
    
}

extension CustomPresentModalViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
							 presenting: UIViewController,
							 source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
            
            transition.presenting = true
			transition.originFrame = avatarImageView.superview!.convert(avatarImageView!.frame, to: nil)
            return transition
    }
    
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
