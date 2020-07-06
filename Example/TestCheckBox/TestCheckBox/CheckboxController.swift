//
//  CheckboxFillController.swift
//  TestCheckBox
//
//  Created by HuyPQ on 2019/06/26.
//  Copyright © 2019 fujitsu. All rights reserved.
//

import UIKit

class CheckboxController {
    //----------------------------
    // MARK: - Properties
    //----------------------------

    /// The path presets for the manager.
    var pathGenerator: PathGenerator = PathGenerator()

    /// The animation presets for the manager.
    var animationGenerator: AnimationGenerator = AnimationGenerator()

    /// The current state of the checkbox.
    var state: CheckState = .unchecked

    /// Whether or not to allow morphong between states.
    var enableMorphing: Bool = true
    
    var checkBoxTintColor: UIColor? = UIColor.black {
        didSet {
            checkBoxLayer.strokeColor = checkBoxTintColor?.cgColor
            checkBoxLayer.fillColor = checkBoxTintColor?.cgColor
        }
    }

    var checkmarkTintColor: UIColor? = UIColor.black {
        didSet {
            markLayer.strokeColor = checkmarkTintColor?.cgColor
        }
    }
    
    var hideBox: Bool = false {
        didSet {
            checkBoxLayer.isHidden = hideBox
        }
    }
    
    init() {
        // Disable som implicit animations.
        let newActions = [
            "opacity": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull(),
            "fillColor": NSNull(),
            "path": NSNull(),
            "lineWidth": NSNull()
        ]

        // Setup the selected box layer.
        checkBoxLayer.lineCap = .round
        checkBoxLayer.rasterizationScale = UIScreen.main.scale
        checkBoxLayer.shouldRasterize = true
        checkBoxLayer.actions = newActions
        checkBoxLayer.transform = CATransform3DIdentity
        
        // Setup the checkmark layer.
        markLayer.lineCap = .round
        markLayer.lineJoin = .round
        markLayer.rasterizationScale = UIScreen.main.scale
        markLayer.shouldRasterize = true
        markLayer.actions = newActions
        
        markLayer.transform = CATransform3DIdentity
        markLayer.fillColor = nil
    }
    
    //----------------------------
    // MARK: - Layers
    //----------------------------
    
    let markLayer = CAShapeLayer()
    let checkBoxLayer = CAShapeLayer()

    var layersToDisplay: [CALayer] {
        return [checkBoxLayer, markLayer]
    }
    
    //----------------------------
    // MARK: - Animations
    //----------------------------
    
    func animate(_ fromState: CheckState?, toState: CheckState?, completion: (() -> Void)? = nil) {
        if let toState = toState {
            state = toState
        }
        
        if pathGenerator.pathForMark(toState) == nil && pathGenerator.pathForMark(fromState) != nil {
            let wiggleAnimation = animationGenerator.fillAnimation(1, amplitude: 0.18, reverse: true)
            let strokeAnimation = animationGenerator.strokeAnimation(true)
            let quickOpacityAnimation = animationGenerator.quickOpacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
                completion?()
            })

            markLayer.add(strokeAnimation, forKey: "strokeEnd")
            markLayer.add(quickOpacityAnimation, forKey: "opacity")
            checkBoxLayer.add(wiggleAnimation, forKey: "transform")

            CATransaction.commit()
        } else if pathGenerator.pathForMark(toState) != nil && pathGenerator.pathForMark(fromState) == nil {
            checkBoxLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            checkBoxLayer.fillColor = checkBoxTintColor?.cgColor
            markLayer.path = pathGenerator.pathForMark(toState)?.cgPath

             let strokeAnimation = animationGenerator.strokeAnimation(false)
             let quickOpacityAnimation = animationGenerator.quickOpacityAnimation(false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
                completion?()
            })

            markLayer.add(strokeAnimation, forKey: "strokeEnd")
            markLayer.add(quickOpacityAnimation, forKey: "opacity")

            CATransaction.commit()
        } else {
            let fromPath = pathGenerator.pathForMark(fromState)
            let toPath = pathGenerator.pathForMark(toState)
            
            let morphAnimation = animationGenerator.morphAnimation(fromPath, toPath: toPath)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                self.resetLayersForState(self.state)
                completion?()
            })
            
            markLayer.add(morphAnimation, forKey: "path")
            
            CATransaction.commit()
        }
        
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    func layoutLayers() {
        // Frames
        checkBoxLayer.frame = CGRect(x: 0.0, y: 0.0, width: pathGenerator.size, height: pathGenerator.size)
        markLayer.frame = CGRect(x: 0.0, y: 0.0, width: pathGenerator.size, height: pathGenerator.size)
        
        // Paths
        checkBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        markLayer.path = pathGenerator.pathForMark(state)?.cgPath
    }
    
    //----------------------------
    // MARK: - Display
    //----------------------------
    
    func resetLayersForState(_ state: CheckState?) {
        if let state = state {
            self.state = state
        }

        layoutLayers()

        // Remove all remnant animations. They will interfere with each other if they are not removed before a new round of animations start.
        checkBoxLayer.removeAllAnimations()
        markLayer.removeAllAnimations()

        checkBoxLayer.strokeColor = checkBoxTintColor?.cgColor
        checkBoxLayer.fillColor = checkBoxTintColor?.cgColor
        checkBoxLayer.lineWidth = pathGenerator.boxLineWidth
        
        markLayer.strokeColor = checkmarkTintColor?.cgColor
        markLayer.lineWidth = pathGenerator.checkmarkLineWidth
        markLayer.fillColor = nil
        
        if pathGenerator.pathForMark(state) != nil {
            checkBoxLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            markLayer.opacity = 1.0
        } else {
            checkBoxLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            markLayer.opacity = 0.0
        }

        // Paths
        checkBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        markLayer.path = pathGenerator.pathForMark(state)?.cgPath
    }
}
