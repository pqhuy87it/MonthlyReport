//
//  DrawView.swift
//  CoreGraphicsPart1
//
//  Created by Pham Quang Huy on 4/15/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var brush: BaseBrush?
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    
    override init(frame: CGRect) {
        self.strokeWidth = 1.0
		self.strokeColor = UIColor.black
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.strokeWidth = 1.0
		self.strokeColor = UIColor.black
        
        super.init(coder: aDecoder)
    }
    
	override func touchesBegan(_ touches: Set<UITouch>, with e: UIEvent?) {
        if let brush = self.brush {
			brush.startPoint = touches.first!.location(in: self)
            brush.endPoint = brush.startPoint
//            self.setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent?) {
        if let brush = self.brush {
			brush.endPoint = touches.first?.location(in: self)
            self.setNeedsDisplay()
        }
    }
    
	override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
		context.setLineCap(CGLineCap.round)
		context.setLineWidth(self.strokeWidth)
		context.setStrokeColor(self.strokeColor.cgColor)

        if let brush = self.brush {
			brush.drawInContext(context: context)
        }
        
		context.strokePath()
    }
}
