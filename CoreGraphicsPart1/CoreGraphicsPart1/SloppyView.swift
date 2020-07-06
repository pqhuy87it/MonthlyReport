//
//  SloppyView.swift
//  CoreGraphicsPart1
//
//  Created by Pham Quang Huy on 4/21/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class SloppyView: UIView {

    var beSloppy = true {
        willSet {
            setNeedsDisplay()
        }
    }
    
	func saveGState(context: CGContext, drawStuff: () -> ()) {
		context.saveGState()
        drawStuff()
		context.restoreGState()
    }
    
	func drawRedCircle(_ context: CGContext, rect: CGRect) {
		context.setStrokeColor(UIColor.red.cgColor)
		context.strokeEllipse(in: rect)
    }
    
    // MARK: Methods - Draw sloppily
	func drawSloppily(_ context:  CGContext) {
		context.setStrokeColor(UIColor.black.cgColor)
		context.setFillColor(UIColor.white.cgColor)
		context.setLineWidth(3.0)
        
		let innerRect = self.bounds.insetBy(dx: 20.0, dy: 20.0)
		context.setStrokeColor(UIColor.orange.cgColor)
		drawRedCircle(context, rect: innerRect)
		context.stroke(innerRect)
    }
    
    // MARK: Methods - Draw nicely
	func drawNicely(_ context: CGContext) {
		context.setStrokeColor(UIColor.black.cgColor)
		context.setFillColor(UIColor.white.cgColor)
		context.setLineWidth(3.0)
        
		let innerRect = self.bounds.insetBy(dx: 20.0, dy: 20.0)
		context.setStrokeColor(UIColor.orange.cgColor)
		saveGState(context: context) {
			self.drawRedCircle(context, rect: innerRect)
        }
		context.stroke(innerRect)
    }
    
    // MARK: Override Draw
	override func draw(_ rect: CGRect) {
		super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        if beSloppy {
            drawSloppily(context)
        } else {
            drawNicely(context)
        }
    }
}
