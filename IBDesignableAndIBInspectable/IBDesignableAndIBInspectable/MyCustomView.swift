//
//  MyCustomView.swift
//  IBDesignableAndIBInspectable
//
//  Created by Exlinct on 1/22/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

@IBDesignable class MyCustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
}
