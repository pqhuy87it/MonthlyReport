//
//  CTButton.swift
//  IBDesignableAndIBInspectable
//
//  Created by Exlinct on 1/22/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

@IBDesignable class CTButton: UIButton {
    @IBInspectable var increaseH: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let titleLabel = self.titleLabel {
            
            var frame = titleLabel.frame
            frame.size.height += self.increaseH
            self.titleLabel?.frame = frame
        }
    }
}

