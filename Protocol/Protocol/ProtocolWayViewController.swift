//
//  ProtocolWayViewController.swift
//  Protocol
//
//  Created by Pham Quang Huy on 2/26/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class ProtocolWayViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel: CustomLabel!
    @IBOutlet weak var loginButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        if loginError() {
            loginButton.doShaking()
            loginButton.doBuzing()
            
            errorMessageLabel.doShaking()
            //errorMessageLabel.doBuzing() -> error
        }
    }
    
    func loginError() -> Bool {
        return true
    }
}
