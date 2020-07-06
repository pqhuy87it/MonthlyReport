//
//  BorderButton.swift
//  UsingDispatchSemaphore
//
//  Created by Huy Pham on 6/24/17.
//  Copyright © 2017 Huy Pham. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable class BorderButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            refreshView()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            refreshView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.redColor() {
        didSet {
            refreshView()
        }
    }
    
    
    @IBInspectable var fillColor: UIColor = UIColor.clearColor() {
        didSet {
            refreshView()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshView()
    }
    
    func refreshView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
        self.layer.backgroundColor = fillColor.CGColor
        self.layoutIfNeeded()
        self.setNeedsDisplay()
    }
}


