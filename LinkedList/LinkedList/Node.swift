//
//  Node.swift
//  LinkedList
//
//  Created by Exlinct on 7/30/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

class Node<T> {
    var data: T?
    var next: Node?
    
    // thuộc tính chỉ dùng với danh sách liên kết kép
    var previous: Node?
}