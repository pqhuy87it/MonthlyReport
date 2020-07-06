//
//  ViewController.swift
//  TestCheckmark
//
//  Created by Huy Pham Quang on 5/26/19.
//  Copyright © 2019 Huy Pham Quang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var checkboxView: CheckboxView!
    @IBOutlet weak var checkmarkView: checkmarkView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkboxView.radioCircle = RadioButtonCircleStyle.init(outerCircle: 25, innerCircle: 10, outerCircleBorder: 5, contentPadding: 20)
        checkmarkView.checkBoxColor = CheckBoxColor(activeColor: UIColor.blue, inactiveColor: UIColor.clear, inactiveBorderColor: UIColor.clear, checkMarkColor: UIColor.white)
        checkmarkView.checkboxLine = CheckboxLineStyle(checkBoxHeight: 40, checkmarkLineWidth: 3, padding: 15)
    }

    @IBAction func btnChangeDidTap(_ sender: Any) {
        self.checkboxView.isOn = !self.checkboxView.isOn
        self.checkmarkView.isOn = !self.checkmarkView.isOn
    }
}

