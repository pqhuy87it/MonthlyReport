//
//  Task.swift
//  UsingDispatchSemaphore
//
//  Created by Huy Pham on 6/23/17.
//  Copyright © 2017 Huy Pham. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (() -> Void)

struct Task {
    var id = 0
    var time = 0
    
    func execute(serviceTask: CompletionHandler, completion: CompletionHandler) {
        print("task: \(self.id) time: \(self.time) is executing.")
        let serialQueue = dispatch_queue_create("serial queue", DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(serialQueue) { 
            sleep(UInt32(self.time))
            completion()
        }
        
        serviceTask()
    }
}