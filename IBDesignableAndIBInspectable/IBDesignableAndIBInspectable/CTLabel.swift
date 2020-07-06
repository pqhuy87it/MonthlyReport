//
//  CTLabel.swift
//  IBDesignableAndIBInspectable
//
//  Created by Exlinct on 1/22/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

@IBDesignable class CTLabel: UILabel {
    @IBInspectable var increaseH: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = super.intrinsicContentSize()
        size.height += increaseH
        return size
    }
}