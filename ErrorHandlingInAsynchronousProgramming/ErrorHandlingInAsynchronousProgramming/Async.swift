//
//  Async.swift
//  ErrorHandlingInAsynchronousProgramming
//
//  Created by Exlinct on 10/29/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

class Async<T> {
    var result: Result = .Waiting
    var handlers:[(() -> Void)] = []
    
    var waiting:Bool {
        switch result {
        case .Failure, .Success: return false
        case .Waiting: return true;
        }
    }
    
    init(value: T) {
        self.result = .Success(value)
    }
    
    init(error: ErrorType) {
        self.result = .Failure(error)
    }
    
    init(_ f:(sucess:T -> Void, failure:ErrorType -> Void) -> Void) {
        func recurse() {
            for handler in handlers {
                handler()
            }
            
            handlers.removeAll(keepCapacity: false)
        }
        
        func failure(err: ErrorType) {
            if self.waiting {
                self.result = .Failure(err);
                recurse();
            }
        }
        func success(obj: T) {
            if self.waiting {
                self.result = .Success(obj);
                recurse()
            }
        }
        
        f(sucess: success, failure: failure)
    }
    
    func dispatch_asyncTask<T>(f:(success: T -> Void, failure: ErrorType ->Void) -> ()) -> Async<T> {
        return Async<T> { (success, failure) in
            dispatch_async(dispatch_get_main_queue()) {
                f(success: success, failure: failure)
            }
        }
    }
    
    func then<U>(f:T -> U) -> Async<U> {
        switch result {
        case .Failure(let error):
            return Async<U>(error: error);
        case .Success(let value):
            return dispatch_asyncTask(){ d in
                d.success(f(value as! T))
            }
        case .Waiting:
            return Async<U> { (success, failure) in
                self.handlers.append {
                    switch self.result {
                    case .Failure(let error):
                        failure(error)
                    case .Success(let value):
                        dispatch_async(dispatch_get_main_queue()) {
                            success(f(value as! T))
                        }
                    case .Waiting:
                        break
                    }
                }
            }
        }
    }
    
    func then<U>(f:T -> Async<U>) -> Async<U> {
        func fill(value:T, success: U -> (), failure: ErrorType -> ()) {
            let promise = f(value)
            switch promise.result {
            case .Failure(let error):
                failure(error)
            case .Success(let value):
                success(value as! U)
            case .Waiting:
                promise.handlers.append{
                    switch promise.result {
                    case .Failure(let error):
                        failure(error)
                    case .Success(let value):
                        success(value as! U)
                    case .Waiting:
                        break
                    }
                }
            }
        }
        
        switch result {
        case .Failure(let error):
            return Async<U>(error: error);
        case .Success(let value):
            return dispatch_asyncTask(){
                fill(value as! T, success: $0, failure: $1)
            }
        case .Waiting:
            return Async<U> { (success, failure) in
                self.handlers.append{
                    switch self.result {
                    case .Waiting:
                        break
                    case .Success(let value):
                        dispatch_async(dispatch_get_main_queue()) {
                            fill(value as! T, success: success, failure: failure)
                        }
                    case .Failure(let error):
                        failure(error)
                    }
                }
            }
        }
    }
    
    func error(f:ErrorType -> T) -> Async<T> {
        switch result {
        case .Success(let value):
            return Async(value:value as! T)
        case .Failure(let error):
            return dispatch_asyncTask(){ (success, _) -> Void in
                success(f(error))
            }
        case .Waiting:
            return Async<T>{ (success, _) in
                self.handlers.append {
                    switch self.result {
                    case .Success(let value):
                        success(value as! T)
                    case .Failure(let error):
                        dispatch_async(dispatch_get_main_queue()){
                            success(f(error))
                        }
                    case .Waiting:
                        break
                    }
                }
            }
        }
    }
}