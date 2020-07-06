//
//  EllipseBrush.swift
//  CoreGraphicsPart1
//
//  Created by Pham Quang Huy on 4/23/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import CoreGraphics

class EllipseBrush: BaseBrush {
	override func drawInContext(context: CGContext) {
		guard let startPoint = self.startPoint,
			let endPoint = self.endPoint else {
            return
        }
        
        var radius = 0.0
        var centerX = abs(endPoint.x - startPoint.x) / 2
        var centerY = abs(endPoint.y - startPoint.y) / 2
        centerX += (startPoint.x < endPoint.x) ? startPoint.x : endPoint.x
        centerY += (startPoint.y < endPoint.y) ? startPoint.y : endPoint.y
        radius = sqrt(pow(Double(endPoint.x) - Double(startPoint.x), 2.0) + pow(Double(endPoint.y) - Double(startPoint.y), 2.0)) / 2
		context.addArc(center: CGPoint(x: centerX, y: centerX),
					   radius: CGFloat(radius),
					   startAngle: 0,
					   endAngle: CGFloat.pi * 2,
					   clockwise: false)
    }
}
