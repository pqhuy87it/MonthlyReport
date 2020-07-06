//
//  Node.swift
//  BinarySearchTree
//
//  Created by Pham Quang Huy on 5/22/18.
//  Copyright © 2018 Pham Quang Huy. All rights reserved.
//

import Foundation

class BSNode<T> {
    var key: T?
    var left: BSNode?
    var right: BSNode?
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    public func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
        }
    }
    
    init() {
        
    }
    
    func traverse() {
        
        //trivial condition
        guard let key = self.key else {
            print("no key provided..")
            return
        }
        
        //process the left side
        if self.left != nil {
            left?.traverse()
        }
        
		print("...the value is: \(key) - height: \(self.height())..")
        
        //process the right side
        if self.right != nil {
            right?.traverse()
        }
    }
    
}
