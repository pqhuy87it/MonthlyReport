//
//  customFunction.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

infix operator |> { associativity left precedence 140 }

typealias Action = () -> Void
typealias AsyncTask = (Action) -> Void

func |>(lhs: AsyncTask, rhs: Action) -> AsyncTask {
    return { (action) -> Void in
        lhs { rhs() ; action() }
    }
}

func |>(lhs: AsyncTask, rhs: Action) -> Action {
    return {
        lhs { rhs() }
    }
}

func |>(lhs: AsyncTask, rhs: AsyncTask) -> AsyncTask {
    return { (action) -> Void in
        lhs { rhs(action) }
    }
}