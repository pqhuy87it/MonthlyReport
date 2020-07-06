//
//  DragDropCollectionView.swift
//  DragDropMultipleCollectionview
//
//  Created by Huy Pham Quang on 8/22/18.
//  Copyright © 2018 みかん方や. All rights reserved.
//

import UIKit

protocol Draggable {
    func canDragAtPoint(_ point : CGPoint) -> Bool
    func representationImageAtPoint(_ point : CGPoint) -> UIView?
    func stylingRepresentationView(_ view: UIView) -> UIView?
    func dataItemAtPoint(_ point : CGPoint) -> AnyObject?
    func dragDataItem(_ item : AnyObject)
    func startDraggingAtPoint(_ point : CGPoint)
    func stopDragging()
}

protocol Droppable {
    func canDropAtRect(_ rect : CGRect) -> Bool
    func willMoveItem(_ item : AnyObject, inRect rect : CGRect)
    func didMoveItem(_ item : AnyObject, inRect rect : CGRect)
    func didMoveOutItem(_ item : AnyObject) -> Void
    func dropDataItem(_ item : AnyObject, atRect : CGRect)
}

public protocol DragDropCollectionViewDataSource : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath?
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject
    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool
    func collectionView(_ collectionView: UICollectionView, stylingRepresentationView: UIView) -> UIView?
}

public protocol DragDropCollectionViewDelegate : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath)
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath)
}

class DragDropCollectionView: UICollectionView, Draggable, Droppable {
    
    var draggingIndexPath: IndexPath?
    var animating: Bool = false
    var paging : Bool = false
    var currentInRect : CGRect?
    
    var isHorizontal : Bool {
        return (self.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    // MARK : Draggable
    public func canDragAtPoint(_ point : CGPoint) -> Bool {
        if let dataSource = self.dataSource as? DragDropCollectionViewDataSource,
            let indexPathOfPoint = self.indexPathForItem(at: point) {
            return dataSource.collectionView(self, cellIsDraggableAtIndexPath: indexPathOfPoint)
        }
        
        return false
    }
    
    public func representationImageAtPoint(_ point : CGPoint) -> UIView? {
        
        guard let indexPath = self.indexPathForItem(at: point) else {
            return nil
        }
        
        guard let cell = self.cellForItem(at: indexPath) else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        imageView.frame = cell.frame
        
        return imageView
    }
    
    public func dataItemAtPoint(_ point : CGPoint) -> AnyObject? {
        
        guard let indexPath = self.indexPathForItem(at: point) else {
            return nil
        }
        
        guard let dragDropDS = self.dataSource as? DragDropCollectionViewDataSource else {
            return nil
        }
        
        return dragDropDS.collectionView(self, dataItemForIndexPath: indexPath)
    }
    
    func startDraggingAtPoint(_ point : CGPoint) -> Void {
        
        self.draggingIndexPath = self.indexPathForItem(at: point)
        
        self.reloadData()
        
    }
    
    public func stopDragging() -> Void {
        
        if let idx = self.draggingIndexPath {
            if let cell = self.cellForItem(at: idx) {
                cell.isHidden = false
            }
        }
        
        self.draggingIndexPath = nil
        
        self.reloadData()
        
    }
    
    // MARK: Droppable
    func checkForEdgesAndScroll(_ rect : CGRect) -> Void {
        
        if paging == true {
            return
        }
        
        let currentRect : CGRect = CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.bounds.size.width, height: self.bounds.size.height)
        var rectForNextScroll : CGRect = currentRect
        
        if isHorizontal {
            
            let leftBoundary = CGRect(x: -30.0, y: 0.0, width: 30.0, height: self.frame.size.height)
            let rightBoundary = CGRect(x: self.frame.size.width, y: 0.0, width: 30.0, height: self.frame.size.height)
            
            if rect.intersects(leftBoundary) == true {
                rectForNextScroll.origin.x -= self.bounds.size.width * 0.5
                if rectForNextScroll.origin.x < 0 {
                    rectForNextScroll.origin.x = 0
                }
            }
            else if rect.intersects(rightBoundary) == true {
                rectForNextScroll.origin.x += self.bounds.size.width * 0.5
                if rectForNextScroll.origin.x > self.contentSize.width - self.bounds.size.width {
                    rectForNextScroll.origin.x = self.contentSize.width - self.bounds.size.width
                }
            }
            
        } else { // is vertical
            
            let topBoundary = CGRect(x: 0.0, y: -30.0, width: self.frame.size.width, height: 30.0)
            let bottomBoundary = CGRect(x: 0.0, y: self.frame.size.height, width: self.frame.size.width, height: 30.0)
            
            if rect.intersects(topBoundary) == true {
                
            } else if rect.intersects(bottomBoundary) == true {
                
            }
        }
        
        // check to see if a change in rectForNextScroll has been made
        if currentRect.equalTo(rectForNextScroll) == false {
            self.paging = true
            self.scrollRectToVisible(rectForNextScroll, animated: true)
            
            let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.paging = false
            }
        }
    }
    
    public func indexPathForCellOverlappingRect( _ rect : CGRect) -> IndexPath? {
        var overlappingArea : CGFloat = 0.0
        var cellCandidate : UICollectionViewCell?
        
        let visibleCells = self.visibleCells
        if visibleCells.count == 0 {
            return IndexPath(row: 0, section: 0)
        }
        
        if  isHorizontal && rect.origin.x > self.contentSize.width ||
            !isHorizontal && rect.origin.y > self.contentSize.height {
            
            return IndexPath(row: visibleCells.count - 1, section: 0)
        }
        
        for visible in visibleCells {
            let intersection = visible.frame.intersection(rect)
            
            if (intersection.width * intersection.height) > overlappingArea {
                overlappingArea = intersection.width * intersection.height
                cellCandidate = visible
            }
        }
        
        if let cellRetrieved = cellCandidate {
            return self.indexPath(for: cellRetrieved)
        }
        
        return nil
    }
    
    public func canDropAtRect(_ rect : CGRect) -> Bool {
        return (self.indexPathForCellOverlappingRect(rect) != nil)
    }
    
    public func dragDataItem(_ item : AnyObject) -> Void {
        
        guard let dragDropDataSource = self.dataSource as? DragDropCollectionViewDataSource else {
            return
        }
        
        guard let dragDropDelegate = self.delegate as? DragDropCollectionViewDelegate else {
            return
        }
        
        guard let existngIndexPath = dragDropDataSource.collectionView(self, indexPathForDataItem: item) else {
            return
            
        }
        
        dragDropDelegate.collectionView(self, deleteDataItemAtIndexPath: existngIndexPath)
        
        if self.animating {
            self.deleteItems(at: [existngIndexPath])
        }
        else {
            
            self.animating = true
            self.performBatchUpdates({ () -> Void in
                self.deleteItems(at: [existngIndexPath])
            }, completion: { complete -> Void in
                self.animating = false
                self.reloadData()
            })
        }
    }
    
    func dropDataItem(_ item: AnyObject, atRect: CGRect) {
        // show hidden cell
        if  let index = draggingIndexPath,
            let cell = self.cellForItem(at: index), cell.isHidden == true {
            
            cell.alpha = 1
            cell.isHidden = false
        }
        
        currentInRect = nil
        self.draggingIndexPath = nil
        self.reloadData()
    }
    
    public func willMoveItem(_ item : AnyObject, inRect rect : CGRect) {
        guard let dragDropDataSource = self.dataSource as?  DragDropCollectionViewDataSource else {
            return
        }
        
        guard let dragDropDelegate = self.delegate as? DragDropCollectionViewDelegate else {
            return
        }
        
        if let _ = dragDropDataSource.collectionView(self, indexPathForDataItem: item) {
            return
        }
        
        if let indexPath = self.indexPathForCellOverlappingRect(rect) {
            dragDropDelegate.collectionView(self, insertDataItem: item, atIndexPath: indexPath)
            self.draggingIndexPath = indexPath
            self.animating = true
            self.performBatchUpdates({ () -> Void in
                self.insertItems(at: [indexPath])
            }, completion: { complete -> Void in
                self.animating = false
                
                if self.draggingIndexPath == nil {
                    self.reloadData()
                }
            })
        }
        
        currentInRect = rect
    }
    
    public func didMoveItem(_ item : AnyObject, inRect rect : CGRect) -> Void {
        guard let dragDropDataSource = self.dataSource as?  DragDropCollectionViewDataSource else {
            return
        }
        
        guard let dragDropDelegate = self.delegate as? DragDropCollectionViewDelegate else {
            return
        }
        
        if let existingIndexPath = dragDropDataSource.collectionView(self, indexPathForDataItem: item),
            let indexPath = self.indexPathForCellOverlappingRect(rect) {
            
            if indexPath.item != existingIndexPath.item {
                
                dragDropDelegate.collectionView(self, moveDataItemFromIndexPath: existingIndexPath, toIndexPath: indexPath)
                
                self.animating = true
                
                self.performBatchUpdates({ () -> Void in
                    self.moveItem(at: existingIndexPath, to: indexPath)
                }, completion: { (finished) -> Void in
                    self.animating = false
                    self.reloadData()
                    
                })
                
                self.draggingIndexPath = indexPath
            }
        }
        
        var normalizedRect = rect
        normalizedRect.origin.x -= self.contentOffset.x
        normalizedRect.origin.y -= self.contentOffset.y
        currentInRect = normalizedRect

        self.checkForEdgesAndScroll(normalizedRect)
    }
    
    public func didMoveOutItem(_ item : AnyObject) {
        guard let dragDropDataSource = self.dataSource as? DragDropCollectionViewDataSource,
            let existngIndexPath = dragDropDataSource.collectionView(self, indexPathForDataItem: item) else {
                
                return
        }
        
        guard let dragDropDelegate = self.delegate as? DragDropCollectionViewDelegate else {
            return
        }
        
        dragDropDelegate.collectionView(self, deleteDataItemAtIndexPath: existngIndexPath)
        
        if self.animating {
            self.deleteItems(at: [existngIndexPath])
        }
        else {
            self.animating = true
            self.performBatchUpdates({ () -> Void in
                self.deleteItems(at: [existngIndexPath])
            }, completion: { (finished) -> Void in
                self.animating = false;
                self.reloadData()
            })
            
        }
        
        if let idx = self.draggingIndexPath {
            if let cell = self.cellForItem(at: idx) {
                cell.isHidden = false
            }
        }
        
        self.draggingIndexPath = nil
        
        currentInRect = nil
    }

    func stylingRepresentationView(_ view: UIView) -> UIView? {
        guard let datasource = self.dataSource as? DragDropCollectionViewDataSource else {
            return nil
        }

        return datasource.collectionView(self, stylingRepresentationView: view)
    }
}
