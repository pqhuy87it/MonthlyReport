//
//  CheckmarkView.swift
//  TestCheckmark
//
//  Created by Huy Pham Quang on 5/26/19.
//  Copyright © 2019 Huy Pham Quang. All rights reserved.
//

import UIKit

class CheckboxView: UIView {

    private var outerLayer = CAShapeLayer()
    private var innerLayer = RadioLayer()

    public var radioCircle = RadioButtonCircleStyle() {
        didSet { setupLayer() }
    }

    @objc dynamic public var isOn = false {
        didSet {
            if isOn != oldValue {
                updateSelectionState()
            }
        }
    }

    public func updateSelectionState() {
        if isOn {
            updateActiveLayer()
        } else {
            updateInactiveLayer()
        }
    }

    /// Apply RadioButtonColor
    public var radioButtonColor: RadioButtonColor! {
        didSet {
            innerLayer.fillColor = radioButtonColor.active.cgColor
            outerLayer.strokeColor = isOn ? radioButtonColor.active.cgColor : radioButtonColor.inactive.cgColor
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        radioButtonColor = RadioButtonColor(active: tintColor, inactive: UIColor.lightGray)
    }

    func setupLayer() {
//        contentEdgeInsets = UIEdgeInsets(top: 0, left: radioCircle.outer + radioCircle.contentPadding, bottom: 0, right: 0)
        // Add layer here
        func addOuterLayer() {
            outerLayer.strokeColor = radioButtonColor.active.cgColor
            outerLayer.fillColor = UIColor.clear.cgColor
            outerLayer.lineWidth = radioCircle.lineWidth
            outerLayer.path = UIBezierPath.outerCircle(rect: bounds, circle: radioCircle).cgPath
            outerLayer.removeFromSuperlayer()
            layer.insertSublayer(outerLayer, at: 0)
        }

        func addInnerLayer() {
            guard let rect = outerLayer.path?.boundingBox else { return }
            innerLayer.fillColor = radioButtonColor.active.cgColor
            innerLayer.strokeColor = UIColor.clear.cgColor
            innerLayer.lineWidth = 0
            innerLayer.activePath = UIBezierPath.innerCircleActive(rect: rect, circle: radioCircle).cgPath
            innerLayer.inactivePath = UIBezierPath.innerCircleInactive(rect: rect).cgPath
            innerLayer.path = innerLayer.inactivePath
            innerLayer.removeFromSuperlayer()
            outerLayer.insertSublayer(innerLayer, at: 0)
        }

        addOuterLayer()
        addInnerLayer()
    }

    func updateActiveLayer() {
//        super.updateActiveLayer()
        outerLayer.strokeColor = radioButtonColor.active.cgColor
        guard let start = innerLayer.path, let end = innerLayer.activePath else { return }
        innerLayer.animatePath(start: start, end: end)
        innerLayer.path = end

    }

    func updateInactiveLayer() {
//        super.updateInactiveLayer()
        outerLayer.strokeColor = radioButtonColor.inactive.cgColor
        guard let start = innerLayer.path, let end = innerLayer.inactivePath else { return }
        innerLayer.animatePath(start: start, end: end)
        innerLayer.path = end
    }
}

// MARK:- CAShapeLayer Stroke animation
internal extension CAShapeLayer {

    func animateStrokeEnd(from: CGFloat, to: CGFloat) {
        self.strokeEnd = from
        self.strokeEnd = to
    }

    func animatePath(start: CGPath, end: CGPath) {
        removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = start
        animation.toValue = end
        animation.isRemovedOnCompletion = true
        add(animation, forKey: "pathAnimation")
    }

}

// MARK:- RadioLayer
internal class RadioLayer: CAShapeLayer {
    /// Path for active layer
    var activePath: CGPath?

    /// Path for inactive layer
    var inactivePath: CGPath?
}

public struct RadioButtonCircleStyle {

    let outer: CGFloat
    let inner: CGFloat
    let lineWidth: CGFloat
    let contentPadding: CGFloat

    public init(outerCircle: CGFloat = 16, innerCircle: CGFloat = 7, outerCircleBorder: CGFloat = 2, contentPadding: CGFloat = 6) {
        self.outer = outerCircle
        self.inner = innerCircle
        self.lineWidth = outerCircleBorder
        self.contentPadding = contentPadding
    }

    public init(outerCircle: CGFloat, innerCircle: CGFloat) {
        self.init(outerCircle: outerCircle, innerCircle: innerCircle, outerCircleBorder: 2, contentPadding: 6)
    }

    public init(outerCircle: CGFloat, innerCircle: CGFloat, outerCircleBorder: CGFloat) {
        self.init(outerCircle: outerCircle, innerCircle: innerCircle, outerCircleBorder: outerCircleBorder, contentPadding: 6)
    }

}

// MARK:- Radio button layer path
private extension UIBezierPath {

    /// Get outer circle layer
    static func outerCircle(rect: CGRect, circle: RadioButtonCircleStyle) -> UIBezierPath {
        let size = CGSize(width: circle.outer, height: circle.outer)
        let newRect = CGRect(origin: CGPoint(x: circle.lineWidth/2, y: rect.size.height/2-(circle.outer/2)), size: size)
        return UIBezierPath(roundedRect: newRect, cornerRadius: size.height/2)
    }

    /// Get inner circle layer
    static func innerCircleActive(rect: CGRect, circle: RadioButtonCircleStyle) -> UIBezierPath {
        let size = CGSize(width: circle.inner, height: circle.inner)
        let origon = CGPoint(x: rect.midX-size.width/2, y: rect.midY-size.height/2)
        let newRect = CGRect(origin: origon, size: size)
        return UIBezierPath(roundedRect: newRect, cornerRadius: size.height/2)
    }

    /// Get inner circle layer for inactive state
    static func innerCircleInactive(rect: CGRect) -> UIBezierPath {
        let origin = CGPoint(x: rect.midX, y: rect.midY)
        let frame = CGRect(origin: origin, size: CGSize.zero)
        return UIBezierPath(rect: frame)
    }

}

public struct RadioButtonColor {

    let active: UIColor
    let inactive: UIColor

    public init(active: UIColor, inactive: UIColor) {
        self.active = active
        self.inactive = inactive
    }

}

