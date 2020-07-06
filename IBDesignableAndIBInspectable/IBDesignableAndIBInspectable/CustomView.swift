//
//  CustomView.swift
//  IBDesignableAndIBInspectable
//
//  Created by Exlinct on 1/22/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class CustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
