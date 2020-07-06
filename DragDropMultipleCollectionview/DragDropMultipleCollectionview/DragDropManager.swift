//
//  DragDropManager.swift
//  DragDropMultipleCollectionview
//
//  Created by Huy Pham Quang on 9/16/18.
//  Copyright © 2018 みかん方や. All rights reserved.
//

import Foundation
import UIKit

public class DragDropManager: NSObject, UIGestureRecognizerDelegate {
    struct Bundle {
        var offset : CGPoint = CGPoint.zero
        var sourceDraggableView : UIView
        var overDroppableView : UIView?
        var representationImageView : UIView
        var dataItem : AnyObject
    }
    
    fileprivate var canvas : UIView = UIView()
    fileprivate var views : [UIView] = []
    fileprivate var longPressGestureRecogniser = UILongPressGestureRecognizer()
    
     var bundle : Bundle?
    
    init(canvas : UIView, collectionViews : [UIView]) {
        
        super.init()
        
        self.canvas = canvas
        
        self.longPressGestureRecogniser.delegate = self
        self.longPressGestureRecogniser.minimumPressDuration = 0.3
        self.longPressGestureRecogniser.addTarget(self, action: #selector(DragDropManager.updateForLongPress(_:)))
        self.canvas.isMultipleTouchEnabled = false
        self.canvas.addGestureRecognizer(self.longPressGestureRecogniser)
        self.views = collectionViews
    }
    
    @objc func updateForLongPress(_ recogniser : UILongPressGestureRecognizer) -> Void {
        
        guard let bundle = self.bundle else { return }
        
        let pointOnCanvas = recogniser.location(in: recogniser.view)
        let sourceDraggable : Draggable = bundle.sourceDraggableView as! Draggable
        let pointOnSourceDraggable = recogniser.location(in: bundle.sourceDraggableView)
        
        switch recogniser.state {
            
            
        case .began :
            self.canvas.addSubview(bundle.representationImageView)
            sourceDraggable.startDraggingAtPoint(pointOnSourceDraggable)
            
        case .changed :
            
            // Update the frame of the representation image
            var repImgFrame = bundle.representationImageView.frame
            repImgFrame.origin = CGPoint(x: pointOnCanvas.x - bundle.offset.x, y: pointOnCanvas.y - bundle.offset.y);
            bundle.representationImageView.frame = repImgFrame
            
            var overlappingAreaMAX: CGFloat = 0.0
            
            var mainOverView: UIView?
            
            for view in self.views where view is Draggable  {
                
                let viewFrameOnCanvas = self.convertRectToCanvas(view.frame, fromView: view)
                let overlappingAreaCurrent = bundle.representationImageView.frame.intersection(viewFrameOnCanvas).area
                
                if overlappingAreaCurrent > overlappingAreaMAX {
                    overlappingAreaMAX = overlappingAreaCurrent
                    mainOverView = view
                }
            }
            
            
            
            if let droppable = mainOverView as? Droppable {
                let rect = self.canvas.convert(bundle.representationImageView.frame, to: mainOverView)
                
                if droppable.canDropAtRect(rect) {
                    
                    if mainOverView != bundle.overDroppableView { // if it is the first time we are entering
                        (bundle.overDroppableView as! Droppable).didMoveOutItem(bundle.dataItem)
                        droppable.willMoveItem(bundle.dataItem, inRect: rect)
                    }
                    
                    // set the view the dragged element is over
                    self.bundle!.overDroppableView = mainOverView
                    droppable.didMoveItem(bundle.dataItem, inRect: rect)
                }
            }
        case .ended :
            
            if bundle.sourceDraggableView != bundle.overDroppableView { // if we are actually dropping over a new view.
                if let droppable = bundle.overDroppableView as? Droppable {
                    sourceDraggable.dragDataItem(bundle.dataItem)
                    let rect = self.canvas.convert(bundle.representationImageView.frame, to: bundle.overDroppableView)
                    droppable.dropDataItem(bundle.dataItem, atRect: rect)
                }
            }
            
            bundle.representationImageView.removeFromSuperview()
            sourceDraggable.stopDragging()
        default:
            break
            
        }
        
    }
    
    // MARK: Helper Methods
    func convertRectToCanvas(_ rect : CGRect, fromView view : UIView) -> CGRect {
        
        var r = rect
        var v = view
        
        while v != self.canvas {
            
            guard let sv = v.superview else { break; }
            
            r.origin.x += sv.frame.origin.x
            r.origin.y += sv.frame.origin.y
            
            v = sv
        }
        
        return r
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard gestureRecognizer.state == .possible else { return false }
        
        for view in self.views where view is Draggable  {
            
            let draggable = view as! Draggable
            
            let touchPointInView = touch.location(in: view)
            
            guard draggable.canDragAtPoint(touchPointInView) == true else { continue }
            
            guard var representation = draggable.representationImageAtPoint(touchPointInView) else { continue }
            
            representation.frame = self.canvas.convert(representation.frame, from: view)
            representation.alpha = 0.5
            if let decoredView = draggable.stylingRepresentationView(representation) {
                representation = decoredView
            }
            
            let pointOnCanvas = touch.location(in: self.canvas)
            
            let offset = CGPoint(x: pointOnCanvas.x - representation.frame.origin.x, y: pointOnCanvas.y - representation.frame.origin.y)
            
            if let dataItem: AnyObject = draggable.dataItemAtPoint(touchPointInView) {
                
                self.bundle = Bundle(
                    offset: offset,
                    sourceDraggableView: view,
                    overDroppableView : view is Droppable ? view : nil,
                    representationImageView: representation,
                    dataItem : dataItem
                )
                
                return true
                
            }
            
        }
        
        return false
        
    }
}
