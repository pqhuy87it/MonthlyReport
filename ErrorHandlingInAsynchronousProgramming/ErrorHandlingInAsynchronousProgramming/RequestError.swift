//
//  RequestError.swift
//  ErrorHandlingInAsynchronousProgramming
//
//  Created by Exlinct on 10/29/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

enum RequestErrors: ErrorType {
    case CouldNotParseJSON
    case NoInternetConnnection
    case UnknowError
}