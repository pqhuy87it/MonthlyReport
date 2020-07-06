//
//  TraditionalWayViewController.swift
//  Protocol
//
//  Created by Pham Quang Huy on 2/26/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class TraditionalWayViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel: ShakingLabel!
    @IBOutlet weak var loginButton: ShakingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        if loginError() {
            errorMessageLabel.doShaking()
            loginButton.doShaking()
        }
    }
    
    
    func loginError() -> Bool {
        return true
    }
}
