//
//  SloppyDrawingViewController.swift
//  CoreGraphicsPart1
//
//  Created by Pham Quang Huy on 4/21/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class SloppyDrawingViewController: UIViewController {

    @IBOutlet var sloppyView: SloppyView!
    
    // MARK: Medthods - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: Methods - Required
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Methods - Convenience
    
    convenience init() {
        let nibNameOrNil = "SloppyDrawingViewController"
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    @IBAction func sloppyChange(sender: UISwitch) {
		sloppyView.beSloppy = sender.isOn
    }
    
}
