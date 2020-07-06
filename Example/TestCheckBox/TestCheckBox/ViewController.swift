//
//  ViewController.swift
//  TestCheckBox
//
//  Created by HuyPQ on 2019/06/26.
//  Copyright © 2019 fujitsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var smallCheckBox: Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTap(_ sender: Any) {
        if self.smallCheckBox.checkState == .unchecked {
             smallCheckBox.setCheckState(.checked, animated: true)
        } else {
            smallCheckBox.setCheckState(.unchecked, animated: true)
        }
    }
    
}

