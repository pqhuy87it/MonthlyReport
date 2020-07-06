//
//  PathGenerator.swift
//  TestCheckBox
//
//  Created by HuyPQ on 2019/06/26.
//  Copyright © 2019 fujitsu. All rights reserved.
//

import UIKit

struct CheckmarkProperties {
    
    /// The angle between the x-axis, and the line created between the origin, and the location where the extended long arm of the checkmark meets the box. (Diagram: Θ)
    var longArmBoxIntersectionAngle: CGFloat = 45.0 * CGFloat(Double.pi / 180.0)
    
    /// The distance from the center the long arm of the checkmark draws to, as a percentage of size. (Diagram: S)
    var longArmRadius: (circle: CGFloat, box: CGFloat) = (circle: 0.22, box: 0.33)
    
    /// The distance from the center of the middle/bottom point of the checkbox, as a percentage of size. (Diagram: T)
    var middlePointRadius: (circle: CGFloat, box: CGFloat) = (circle: 0.133, box: 0.1995)
    
    /// The distance between the horizontal center and the middle point of the checkbox.
    var middlePointOffset: (circle: CGFloat, box: CGFloat) = (circle: -0.04, box: -0.06)
    
    /// The distance from the center of the left most point of the checkmark, as a percentage of size.
    var shortArmRadius: (circle: CGFloat, box: CGFloat) = (circle: 0.17, box: 0.255)
    
    /// The distance between the vertical center and the left most point of the checkmark, as a percentage of size.
    var shortArmOffset: (circle: CGFloat, box: CGFloat) = (circle: 0.02, box: 0.03)
}

class PathGenerator {
    /// The maximum width or height the path will be generated with.
    var size: CGFloat = 0.0
    
    /// The line width of the created checkmark.
    var checkmarkLineWidth: CGFloat = 1.0
    
    /// The line width of the created box.
    var boxLineWidth: CGFloat = 0.0
    
    /// The corner radius of the box.
    var cornerRadius: CGFloat = 3.0
    
//    var boxType: BoxType = .circle

    var checkmarkProperties: CheckmarkProperties = CheckmarkProperties()
    
    var checkmarkLongArmBoxIntersectionPoint: CGPoint {
        let boxLineWidth: CGFloat = self.boxLineWidth
        let size: CGFloat = self.size
        
        let radius: CGFloat = (size - boxLineWidth) / 2.0
        let theta:CGFloat = checkmarkProperties.longArmBoxIntersectionAngle
        // Basic trig to get the location of the point on the circle.
        let x: CGFloat = (size / 2.0) + (radius * cos(theta))
        let y: CGFloat = (size / 2.0) - (radius * sin(theta))
        return CGPoint(x: x, y: y)
    }
    
    var checkmarkLongArmEndPoint: CGPoint {
        let size: CGFloat = self.size
        let boxLineWidth: CGFloat = self.boxLineWidth
        
        // Known variables
        let boxEndPoint: CGPoint = checkmarkLongArmBoxIntersectionPoint
        let x2: CGFloat = boxEndPoint.x
        let y2: CGFloat = boxEndPoint.y
        let midPoint: CGPoint = checkmarkMiddlePoint
        let x1: CGFloat = midPoint.x
        let y1: CGFloat = midPoint.y
        let r: CGFloat = size * checkmarkProperties.longArmRadius.circle
        
        let a1: CGFloat = (size * pow(x1, 2.0)) - (2.0 * size * x1 * x2) + (size * pow(x2, 2.0)) + (size * x1 * y1) - (size * x2 * y1)
        let a2: CGFloat = (2.0 * x2 * pow(y1, 2.0)) - (size * x1 * y2) + (size * x2 * y2) - (2.0 * x1 * y1 * y2) - (2.0 * x2 * y1 * y2) + (2.0 * x1 * pow(y2, 2.0))
        
        let b: CGFloat = -16.0 * (pow(x1, 2.0) - (2.0 * x1 * x2) + pow(x2, 2.0) + pow(y1, 2.0) - (2.0 * y1 * y2) + pow(y2, 2.0))
        
        let c1: CGFloat = pow(r, 2.0) * ((-pow(x1, 2.0)) + (2.0 * x1 * x2) - pow(x2, 2.0))
        let c2: CGFloat = pow(size, 2.0) * ((0.5 * pow(x1, 2.0)) - (x1 * x2) + (0.5 * pow(x2, 2.0)))
        
        let d1: CGFloat = (pow(x2, 2.0) * pow(y1, 2.0)) - (2.0 * x1 * x2 * y1 * y2) + (pow(x1, 2.0) * pow(y2, 2.0))
        let d2: CGFloat = size * ((x1 * x2 * y1) - (pow(x2, 2.0) * y1) - (pow(x1, 2.0) * y2) + (x1 * x2 * y2))
        
        let cd: CGFloat = c1 + c2 + d1 + d2
        
        let e1: CGFloat = (x1 * ((4.0 * y1) - (4.0 * y2)) * y2) + (x2 * y1 * ((-4.0 * y1) + (4.0 * y2)))
        let e2: CGFloat = size * ((-2.0 * pow(x1, 2.0)) + (x2 * ((-2.0 * x2) + (2.0 * y1) - (2.0 * y2))) + (x1 * (4.0 * x2 - (2.0 * y1) + (2.0 * y2))))
        
        let f: CGFloat = pow(x1, 2.0) - (2.0 * x1 * x2) + pow(x2, 2.0) + pow(y1, 2.0) - (2.0 * y1 * y2) + pow(y2, 2)
        
        let g1: CGFloat = (0.5 * size * x1 * y1) - (0.5 * size * x2 * y1) - (x1 * x2 * y1) + (pow(x2, 2.0) * y1) + (0.5 * size * pow(y1, 2.0))
        let g2: CGFloat = (-0.5 * size * x1 * y2) + (pow(x1, 2.0) * y2) + (0.5 * size * x2 * y2) - (x1 * x2 * y2) - (size * y1 * y2) + (0.5 * size * pow(y2, 2.0))
        
        let h1: CGFloat = (-4.0 * pow(x2, 2.0) * y1) - (4.0 * pow(x1, 2.0) * y2) + (x1 * x2 * ((4.0 * y1) + (4.0 * y2)))
        let h2: CGFloat = size * ((-2.0 * x1 * y1) + (2.0 * x2 * y1) - (2.0 * pow(y1, 2.0)) + (2.0 * x1 * y2) - (2.0 * x2 * y2) + (4.0 * y1 * y2) - (2.0 * pow(y2, 2.0)))
        
        let i: CGFloat = (pow(r, 2.0) * (-pow(y1, 2.0) + (2.0 * y1 * y2) - pow(y2, 2.0))) + (pow(size, 2.0) * ((0.5 * pow(y1, 2.0)) - (y1 * y2) + (0.5 * pow(y2, 2.0))))
        let j: CGFloat = size * ((x1 * (y1 - y2) * y2) + (x2 * y1 * (-y1 + y2)))
        
        let powE1E2: CGFloat = pow(e1 + e2, 2.0)
        let subX1: CGFloat = (b * cd) + powE1E2
        let subX2: CGFloat = (a1 + a2 + (0.5 * sqrt(subX1)))
        
        let powH1H2: CGFloat = pow(h1 + h2, 2.0)
        let subY1: CGFloat = powH1H2 + (b * (d1 + i + j))
        let subY2: CGFloat = (0.25 * sqrt(subY1))
        
        let x: CGFloat = (0.5 * subX2 + (boxLineWidth / 2.0)) / f
        let y: CGFloat = (g1 + g2 - subY2 + (boxLineWidth / 2.0)) / f
        
        return CGPoint(x: x, y: y)
    }
    
    var checkmarkMiddlePoint: CGPoint {
        let r: CGFloat = checkmarkProperties.middlePointRadius.circle
        let o: CGFloat = checkmarkProperties.middlePointOffset.circle
        let x: CGFloat = (size / 2.0) + (size * o)
        let y: CGFloat = (size / 2.0 ) + (size * r)
        return CGPoint(x: x, y: y)
    }
    
    var checkmarkShortArmEndPoint: CGPoint {
        let r: CGFloat = checkmarkProperties.shortArmRadius.circle
        let o: CGFloat = checkmarkProperties.shortArmOffset.circle
        let x: CGFloat = (size / 2.0) - (size * r)
        let y: CGFloat = (size / 2.0) + (size * o)
        return CGPoint(x: x, y: y)
    }
    
    func pathForBox() -> UIBezierPath? {
        let radius = (size - boxLineWidth) / 2.0
        // Create a circle that starts in the top right hand corner.
        return UIBezierPath(arcCenter: CGPoint(x: size / 2.0, y: size / 2.0),
                            radius: radius,
                            startAngle: -(CGFloat.pi / 2),
                            endAngle: CGFloat((2 * Double.pi) - (Double.pi / 2)),
                            clockwise: true)
    }
    
    func pathForMark(_ state: CheckState?) -> UIBezierPath? {
        
        guard let state = state else {
            return nil
        }
        
        switch state {
        case .unchecked:
            return pathForUnselectedMark()
        case .checked:
            return pathForMark()
        }
    }
    
    func pathForMark() -> UIBezierPath? {
        let path = UIBezierPath()
        
        path.move(to: checkmarkShortArmEndPoint)
        path.addLine(to: checkmarkMiddlePoint)
        path.addLine(to: checkmarkLongArmEndPoint)
        
        return path
    }
    
    func pathForUnselectedMark() -> UIBezierPath? {
        return nil
    }
}
