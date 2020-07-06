//
//  PenBrush.swift
//  CoreGraphicsPart1
//
//  Created by Pham Quang Huy on 4/15/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class LineBrush: BaseBrush {
	override func drawInContext(context: CGContext) {
		guard let startPoint = self.startPoint,
			let endPoint = self.endPoint else {
            return
        }
        
		context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
		context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
    }
}
