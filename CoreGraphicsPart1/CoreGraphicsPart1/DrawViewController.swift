//
//  DrawViewController.swift
//  CoreGraphicsPart1
//
//  Created by Pham Quang Huy on 4/13/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    // MARK: Parameters - UIKit
    @IBOutlet var drawView: DrawView! {
        didSet {
            drawView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
    }
    @IBOutlet var brushSegmentedControl: UISegmentedControl!
    
    // MARK: Parameters - User
    
    var brushes = [LineBrush(), SquareBrush(), EllipseBrush() ,CircleBrush()]
    
    // MARK: Medthods - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.drawView.brush = LineBrush()
    }
    
    // MARK: Methods - IBActions
    
    @IBAction func brushSegmentedControlValueChange(sender: UISegmentedControl) {
        drawView.brush = brushes[sender.selectedSegmentIndex]
    }

}
