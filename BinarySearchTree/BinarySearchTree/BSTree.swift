//
//  BSTree.swift
//  BinarySearchTree
//
//  Created by Pham Quang Huy on 5/22/18.
//  Copyright © 2018 Pham Quang Huy. All rights reserved.
//

import Foundation

class BSTree<T: Comparable> {
    var root = BSNode<T>()
    
    func insert(element key: T) {
        // init root
        guard root.key != nil else {
            root.key = key
            return
        }
        
        var current: BSNode<T> = root
        
        while current.key != nil {
            if key < current.key! {
                if let leftBSNode = current.left {
                    current = leftBSNode
                } else {
                    let childBSNode = BSNode<T>()
                    childBSNode.key = key
                    current.left = childBSNode
                    break
                }
            } else if key > current.key! {
                if let rightBSNode = current.right {
                    current = rightBSNode
                } else {
                    let childBSNode = BSNode<T>()
                    childBSNode.key = key
                    current.right = childBSNode
                    break
                }
            }
        }
    }
    
    public func search(value: T) -> BSNode<T>? {
        var node: BSNode<T>? = self.root
        
        while let n = node {
            if value < n.key! {
                node = n.left
            } else if value > n.key! {
                node = n.right
            } else {
                return node
            }
        }
        
        return nil
    }
}
