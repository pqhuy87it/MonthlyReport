//
//  AvatarViewController.swift
//  CusomPresentViewController
//
//  Created by Exlinct on 11/26/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.setRounded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismissPressed(sender: AnyObject) {
		presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
