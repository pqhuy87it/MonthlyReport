//
//  checkmarkView.swift
//  TestCheckmark
//
//  Created by Huy Pham Quang on 5/26/19.
//  Copyright © 2019 Huy Pham Quang. All rights reserved.
//

import UIKit

class checkmarkView: UIView {

    private var outerLayer = CAShapeLayer()
    private var checkMarkLayer = CAShapeLayer()
    
    public var checkBoxColor: CheckBoxColor! {
        didSet {
//            if radioButtonColorDidSetCall {
                checkMarkLayer.strokeColor = checkBoxColor.checkMarkColor.cgColor
                updateSelectionState()
//            }
        }
    }

    @objc dynamic public var isOn = false {
        didSet {
            if isOn != oldValue {
                updateSelectionState()
            }
        }
    }

    public var checkboxLine = CheckboxLineStyle() {
        didSet {
            setupLayer()
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
        checkBoxColor = CheckBoxColor(activeColor: tintColor, inactiveColor: UIColor.clear, inactiveBorderColor: UIColor.lightGray, checkMarkColor: UIColor.white)
    }

    func setupLayer() {
//        contentEdgeInsets = UIEdgeInsets(top: 0, left: checkboxLine.checkBoxHeight + checkboxLine.padding, bottom: 0, right: 0)
        // Make inner later here
        let origin = CGPoint(x: 1, y: bounds.midY - (checkboxLine.checkBoxHeight/2))
        let rect = CGRect(origin: origin, size: checkboxLine.size)
        outerLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: checkboxLine.size.height/2).cgPath
        outerLayer.lineWidth = 2
        outerLayer.removeFromSuperlayer()
        layer.insertSublayer(outerLayer, at: 0)

        let path = UIBezierPath()
        var xPos: CGFloat = (rect.width * 0.15) + origin.x
        var yPos = rect.midY
        path.move(to: CGPoint(x: xPos, y: yPos))

        var checkMarkLength = (rect.width/2 - xPos)

        [45.0, -45.0].forEach {
            xPos = xPos + checkMarkLength * CGFloat(cos($0 * .pi/180))
            yPos = yPos + checkMarkLength * CGFloat(sin($0 * .pi/180))
            path.addLine(to: CGPoint(x: xPos, y: yPos))
            checkMarkLength *= 2
        }

        checkMarkLayer.lineWidth = checkboxLine.checkmarkLineWidth == -1 ? max(checkboxLine.checkBoxHeight*0.1, 2) : checkboxLine.checkmarkLineWidth
        checkMarkLayer.strokeColor = checkBoxColor.checkMarkColor.cgColor
        checkMarkLayer.path = path.cgPath
        checkMarkLayer.fillColor = UIColor.clear.cgColor
        checkMarkLayer.removeFromSuperlayer()
        outerLayer.insertSublayer(checkMarkLayer, at: 0)

//        super.setupLayer()
    }

    func updateActiveLayer() {
        checkMarkLayer.animateStrokeEnd(from: 0, to: 1)
        outerLayer.fillColor = checkBoxColor.activeColor.cgColor
        outerLayer.strokeColor = checkBoxColor.activeColor.cgColor
    }

    func updateInactiveLayer() {
        checkMarkLayer.animateStrokeEnd(from: 1, to: 0)
        outerLayer.fillColor = checkBoxColor.inactiveColor.cgColor
        outerLayer.strokeColor = checkBoxColor.inactiveBorderColor.cgColor
    }

    public func updateSelectionState() {
        if isOn {
            updateActiveLayer()
        } else {
            updateInactiveLayer()
        }
    }
}

public struct CheckBoxColor {

    let activeColor: UIColor
    let inactiveColor: UIColor
    let inactiveBorderColor: UIColor
    let checkMarkColor: UIColor

    public init(activeColor: UIColor, inactiveColor: UIColor, inactiveBorderColor: UIColor, checkMarkColor: UIColor) {
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.inactiveBorderColor = inactiveBorderColor
        self.checkMarkColor = checkMarkColor
    }

}

public struct CheckboxLineStyle {

    let checkBoxHeight: CGFloat
    let checkmarkLineWidth: CGFloat
    let padding: CGFloat

    public init(checkBoxHeight: CGFloat, checkmarkLineWidth: CGFloat = -1, padding: CGFloat = 6) {
        self.checkBoxHeight = checkBoxHeight
        self.checkmarkLineWidth = checkmarkLineWidth
        self.padding = padding
    }

    public init(checkmarkLineWidth: CGFloat, padding: CGFloat = 6) {
        self.init(checkBoxHeight: 18, checkmarkLineWidth: checkmarkLineWidth, padding: padding)
    }

    public init(padding: CGFloat = 6) {
        self.init(checkmarkLineWidth: -1, padding: padding)
    }

    public var size: CGSize {
        return CGSize(width: checkBoxHeight, height: checkBoxHeight)
    }
}
