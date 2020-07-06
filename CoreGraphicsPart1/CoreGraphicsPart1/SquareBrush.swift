//
//  SquareBrush.swift
//  CoreGraphicsPart1
//
//  Created by Pham Quang Huy on 4/15/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import CoreGraphics

class SquareBrush: BaseBrush {
	override func drawInContext(context: CGContext) {
		guard let startPoint = self.startPoint, let endPoint = self.endPoint else {
            return
        }
		let origin = CGPoint(x: min(startPoint.x, endPoint.x), y: min(startPoint.y, endPoint.y))
		let size = CGSize(width: abs(endPoint.x - startPoint.x), height: abs(endPoint.y - startPoint.y))
		context.addRect(CGRect(origin: origin, size: size))
    }
}
