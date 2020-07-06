//
//  SemaphoreManager.swift
//  UsingDispatchSemaphore
//
//  Created by Huy Pham on 6/23/17.
//  Copyright © 2017 Huy Pham. All rights reserved.
//

import Foundation
import UIKit

protocol SemaphoreManagerDelegate: class {
    func didFinishService()
}

class SemaphoreManager {
    let serialQueue = dispatch_queue_create("serial queue", DISPATCH_QUEUE_SERIAL)
    let semaphore: dispatch_semaphore_t
    var isServicing = false
    var tasks = [Task]()
    var currentTaskIndex = 0
    var numberThread = 0
    
    weak var delegate: SemaphoreManagerDelegate?
    
    init(numberThread: Int) {
        self.numberThread = numberThread
        self.semaphore = dispatch_semaphore_create(numberThread)
    }
    
    func getTasks(tasks: [Task]) {
        self.isServicing = true
        self.tasks = tasks
        self.startServicing()
    }
    
    func startServicing() {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
        
        if currentTaskIndex > tasks.count - 1 {
            if let delegate = self.delegate {
                delegate.didFinishService()
            }
        } else {
            dispatch_async(serialQueue, {
                self.tasks[self.currentTaskIndex].execute({ 
                        self.nextTask()
                    }, completion: { 
                        if self.isServicing {
                            dispatch_semaphore_signal(self.semaphore)
                        }
                })
            })
        }
    }
    
    func nextTask() {
        currentTaskIndex += 1
        
        if self.isServicing {
            self.startServicing()
        }
    }
    
    func pause() {
        isServicing = false
    }
    
    func stop() {
        isServicing = false
        
        tasks.removeAll()
        currentTaskIndex = 0

        for _ in 0..<numberThread {
            dispatch_semaphore_signal(semaphore)
        }
    }
    
    func resume() {
        isServicing = true

        for _ in 0..<numberThread {
            dispatch_semaphore_signal(semaphore)
        }
    }
}