https://stackoverflow.com/questions/11909629/waiting-until-two-async-blocks-are-executed-before-starting-another-block

#1. Using DispatchGroup, DispatchGroup's notify(qos:flags:queue:execute:) and DispatchQueue's async(group:qos:flags:execute:)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "com.company.app.queue", attributes: .concurrent)
let group = DispatchGroup()

queue.async(group: group) {
    print("#1 started")
    Thread.sleep(forTimeInterval: 5)
    print("#1 finished")
}

queue.async(group: group) {
    print("#2 started")
    Thread.sleep(forTimeInterval: 2)
    print("#2 finished")
}

group.notify(queue: queue) {
    print("#3 finished")
}

/*
 prints:
 #1 started
 #2 started
 #2 finished
 #1 finished
 #3 finished
 */
 
 #2. Using DispatchGroup, DispatchGroup's wait(), DispatchGroup's enter() and DispatchGroup's leave()
 
 import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "com.company.app.queue", attributes: .concurrent)
let group = DispatchGroup()

group.enter()
queue.async {
    print("#1 started")
    Thread.sleep(forTimeInterval: 5)
    print("#1 finished")
    group.leave()
}

group.enter()
queue.async {
    print("#2 started")
    Thread.sleep(forTimeInterval: 2)
    print("#2 finished")
    group.leave()
}

queue.async {
    group.wait()
    print("#3 finished")
}

/*
 prints:
 #1 started
 #2 started
 #2 finished
 #1 finished
 #3 finished
 */
 
 #3. Using Dispatch​Work​Item​Flags barrier and DispatchQueue's async(group:qos:flags:execute:)
 
 import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "com.company.app.queue", attributes: .concurrent)

queue.async {
    print("#1 started")
    Thread.sleep(forTimeInterval: 5)
    print("#1 finished")
}

queue.async {
    print("#2 started")
    Thread.sleep(forTimeInterval: 2)
    print("#2 finished")
}

queue.async(flags: .barrier) {
    print("#3 finished")
}

/*
 prints:
 #1 started
 #2 started
 #2 finished
 #1 finished
 #3 finished
 */
 
 #4. Using DispatchWorkItem, Dispatch​Work​Item​Flags's barrier and DispatchQueue's async(execute:)
 
 import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "com.company.app.queue", attributes: .concurrent)

queue.async {
    print("#1 started")
    Thread.sleep(forTimeInterval: 5)
    print("#1 finished")
}

queue.async {
    print("#2 started")
    Thread.sleep(forTimeInterval: 2)
    print("#2 finished")
}

let dispatchWorkItem = DispatchWorkItem(qos: .default, flags: .barrier) {
    print("#3 finished")
}

queue.async(execute: dispatchWorkItem)

/*
 prints:
 #1 started
 #2 started
 #2 finished
 #1 finished
 #3 finished
 */
 
 #5. Using DispatchSemaphore, DispatchSemaphore's wait() and DispatchSemaphore's signal()
 
 import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "com.company.app.queue", attributes: .concurrent)
let semaphore = DispatchSemaphore(value: 0)

queue.async {
    print("#1 started")
    Thread.sleep(forTimeInterval: 5)
    print("#1 finished")
    semaphore.signal()
}

queue.async {
    print("#2 started")
    Thread.sleep(forTimeInterval: 2)
    print("#2 finished")
    semaphore.signal()
}

queue.async {
    semaphore.wait()
    semaphore.wait()    
    print("#3 finished")
}

/*
 prints:
 #1 started
 #2 started
 #2 finished
 #1 finished
 #3 finished
 */
 
 #6. Using OperationQueue and Operation's addDependency(_:)
 
 import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let operationQueue = OperationQueue()

let blockOne = BlockOperation {
    print("#1 started")
    Thread.sleep(forTimeInterval: 5)
    print("#1 finished")
}

let blockTwo = BlockOperation {
    print("#2 started")
    Thread.sleep(forTimeInterval: 2)
    print("#2 finished")
}

let blockThree = BlockOperation {
    print("#3 finished")
}

blockThree.addDependency(blockOne)
blockThree.addDependency(blockTwo)

operationQueue.addOperations([blockThree, blockTwo, blockOne], waitUntilFinished: false)

/*
 prints:
 #1 started
 #2 started
 #2 finished
 #1 finished
 #3 finished
 or
 #2 started
 #1 started
 #2 finished
 #1 finished
 #3 finished
 */
 
 #7. Using OperationQueue and OperationQueue's addBarrierBlock(_:) (requires iOS 13)
 
 import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let operationQueue = OperationQueue()

let blockOne = BlockOperation {
    print("#1 started")
    Thread.sleep(forTimeInterval: 5)
    print("#1 finished")
}

let blockTwo = BlockOperation {
    print("#2 started")
    Thread.sleep(forTimeInterval: 2)
    print("#2 finished")
}

operationQueue.addOperations([blockTwo, blockOne], waitUntilFinished: false)
operationQueue.addBarrierBlock {
    print("#3 finished")
}

/*
 prints:
 #1 started
 #2 started
 #2 finished
 #1 finished
 #3 finished
 or
 #2 started
 #1 started
 #2 finished
 #1 finished
 #3 finished
 */
 
 
