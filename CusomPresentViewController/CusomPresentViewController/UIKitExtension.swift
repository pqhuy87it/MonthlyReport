//
//  UIKitExtension.swift
//  CusomPresentViewController
//
//  Created by Exlinct on 11/26/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    public func setRounded() {
		let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
