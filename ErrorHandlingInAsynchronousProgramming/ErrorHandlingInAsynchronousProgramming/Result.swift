//
//  Result.swift
//  ErrorHandlingInAsynchronousProgramming
//
//  Created by Exlinct on 10/29/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

enum Result {
    case Waiting
    case Success(Any)
    case Failure(ErrorType)
}