//
//  Synchronizable.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

protocol Synchronizable {
    associatedtype Element
    var items: [Element] { get }
    func synchronize(completion: Action)
}