//
//  Promise.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 10/23/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

class Promise<T> {
    // the monadic equivalent of "map", which is usually called "then" in the Promise type
    func then<U>(f: T->U) -> Promise<U> {
        
    }
    // the monadic equivalent of "flatMap", which is usually called "then" too
    func then<U>(f: T->Promise<U>) -> Promise<U>
}