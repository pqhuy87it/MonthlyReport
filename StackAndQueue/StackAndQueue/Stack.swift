//
//  Stack.swift
//  StackAndQueue
//
//  Created by Pham Quang Huy on 12/25/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

class Stack<T> {
    var top: Node<T>! = Node<T>()
    
    func push(_ key: T) {
        // neu ngan xep chua co dinh
        if top == nil {
            top = Node<T>()
        }
        
        // neu dinh ngan xep rong
        if top.key ==  nil {
            top.key = key
            return
        } else { // khong thi tao 1 nut moi roi gan nut do vao dinh
            let newNode = Node<T>()
            newNode.key = key
            newNode.next = top
            top = newNode
        }
    }
    
    func pop() -> T? {
        // kiem tra xem dinh danh sach co rong khong
        // neu rong thi ket thuc
        guard top != nil else {
            return nil
        }
        
        guard let popItem = top.key else {
            return nil
        }
        
        // kiem tra xem nut tiep theo cua dinh co rong khoong
        if let nextNode = top.next {
            top = nextNode
        } else {
            top = nil
        }
        
        return popItem
    }
    
    func peek() -> T? {
        // kiem tra xem dinh dach sach co rong khong
        guard let topItem = top.key else {
            // neu rong thi tra ve nil
            return nil
        }
        
        // con khong tra ve gia tri dinh danh sach
        return topItem
    }
}
