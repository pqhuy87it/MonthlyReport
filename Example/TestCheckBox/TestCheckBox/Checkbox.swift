//
//  Checkbox.swift
//  TestCheckBox
//
//  Created by HuyPQ on 2019/06/26.
//  Copyright © 2019 fujitsu. All rights reserved.
//

import Foundation
import UIKit

public enum CheckState: String {
    /// No check is shown.
    case unchecked = "Unchecked"
    /// A checkmark is shown.
    case checked = "Checked"
}

class Checkbox: UIControl {
    /// The manager that manages display and animations of the checkbox.
    /// The default animation is a stroke.
    fileprivate var controller = CheckboxController()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    /// The setup shared between initalizers.
    fileprivate func sharedSetup() {
        // Set up the inital state.
        for aLayer in controller.layersToDisplay {
            layer.addSublayer(aLayer)
        }
        controller.checkBoxTintColor = tintColor
        controller.resetLayersForState(.unchecked)
        
        let longPressGesture = CheckboxGestureRecognizer(target: self, action: #selector(Checkbox.handleLongPress(_:)))
        addGestureRecognizer(longPressGesture)
    }
    
    //----------------------------
    // MARK: - Values
    //----------------------------
    
    /// The object to return from `value` when the checkbox is checked.
    open var checkedValue: Any?
    
    /// The object to return from `value` when the checkbox is unchecked.
    open var uncheckedValue: Any?
    
    /// The object to return from `value` when the checkbox is mixed.
    open var mixedValue: Any?
    
    open var value: Any? {
        switch checkState {
        case .unchecked:
            return uncheckedValue
        case .checked:
            return checkedValue
        }
    }
    
    open var checkState: CheckState {
        get {
            return controller.state
        }
        set {
            setCheckState(newValue, animated: false)
        }
    }
    
    open func setCheckState(_ newState: CheckState, animated: Bool) {
        if checkState == newState {
            return
        }
        
        if animated {
            if enableMorphing {
                controller.animate(checkState, toState: newState)
            } else {
                controller.animate(checkState, toState: nil, completion: { [weak self] in
                    self?.controller.resetLayersForState(newState)
                    self?.controller.animate(nil, toState: newState)
                })
            }
        } else {
            controller.resetLayersForState(newState)
        }
    }
    
    open func toggleCheckState(_ animated: Bool = false) {
        switch checkState {
        case .checked:
            setCheckState(.unchecked, animated: animated)
            break
        case .unchecked:
            setCheckState(.checked, animated: animated)
            break
        }
    }
    
    @IBInspectable open var animationDuration: Double {
        get {
            return controller.animationGenerator.animationDuration
        }
        set {
            controller.animationGenerator.animationDuration = newValue
        }
    }
    
    @IBInspectable open var enableMorphing: Bool {
        get {
            return controller.enableMorphing
        }
        set {
            controller.enableMorphing = newValue
        }
    }

    @IBInspectable open var checkMarkColor: UIColor? {
        get {
            return controller.checkmarkTintColor
        }
        set {
            controller.checkmarkTintColor = newValue
        }
    }

    @IBInspectable open var checkBoxColor: UIColor? {
        get {
            return controller.checkBoxTintColor
        }
        set {
            controller.checkBoxTintColor = newValue
        }
    }
    
    @IBInspectable open var checkmarkLineWidth: CGFloat {
        get {
            return controller.pathGenerator.checkmarkLineWidth
        }
        set {
            controller.pathGenerator.checkmarkLineWidth = newValue
            controller.resetLayersForState(checkState)
        }
    }
    
//    @IBInspectable open var boxLineWidth: CGFloat {
//        get {
//            return controller.pathGenerator.boxLineWidth
//        }
//        set {
//            controller.pathGenerator.boxLineWidth = newValue
//            controller.resetLayersForState(checkState)
//        }
//    }

//    @IBInspectable open var cornerRadius: CGFloat {
//        get {
//            return controller.pathGenerator.cornerRadius
//        }
//        set {
//            controller.pathGenerator.cornerRadius = newValue
//            setNeedsLayout()
//        }
//    }

//    open var boxType: BoxType {
//        get {
//            return controller.pathGenerator.boxType
//        }
//        set {
//            controller.pathGenerator.boxType = newValue
//            setNeedsLayout()
//        }
//    }
    
    @IBInspectable open var hideBox: Bool {
        get {
            return controller.hideBox
        }
        set {
            controller.hideBox = newValue
        }
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        controller.checkBoxTintColor = tintColor
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        // Update size
        controller.pathGenerator.size = min(frame.size.width, frame.size.height)
        // Layout
        controller.layoutLayers()
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            isSelected = true
        } else {
            isSelected = false
            if sender.state == .ended {
                toggleCheckState(true)
                sendActions(for: .valueChanged)
            }
        }
    }
    
}
