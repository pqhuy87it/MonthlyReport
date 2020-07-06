https://stackoverflow.com/questions/11909629/waiting-until-two-async-blocks-are-executed-before-starting-another-block

#1. Using DispatchGroup, DispatchGroup's notify(qos:flags:queue:execute:) and DispatchQueue's async(group:qos:flags:execute:)
The Apple Developer Concurrency Programming Guide states about DispatchGroup:

Dispatch groups are a way to block a thread until one or more tasks finish executing. You can use this behavior in places where you cannot make progress until all of the specified tasks are complete. For example, after dispatching several tasks to compute some data, you might use a group to wait on those tasks and then process the results when they are done.

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
Note that you can also mix DispatchGroup wait() with DispatchQueue async(group:qos:flags:execute:) or mix DispatchGroup enter() and DispatchGroup leave() with DispatchGroup notify(qos:flags:queue:execute:).

#3. Using Dispatch​Work​Item​Flags barrier and DispatchQueue's async(group:qos:flags:execute:)
Grand Central Dispatch Tutorial for Swift 4: Part 1/2 article from Raywenderlich.com gives a definition for barriers:

Dispatch barriers are a group of functions acting as a serial-style bottleneck when working with concurrent queues. When you submit a DispatchWorkItem to a dispatch queue you can set flags to indicate that it should be the only item executed on the specified queue for that particular time. This means that all items submitted to the queue prior to the dispatch barrier must complete before the DispatchWorkItem will execute.

Usage:

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
Soroush Khanlou wrote the following lines in The GCD Handbook blog post:

Using a semaphore, we can block a thread for an arbitrary amount of time, until a signal from another thread is sent. Semaphores, like the rest of GCD, are thread-safe, and they can be triggered from anywhere. Semaphores can be used when there’s an asynchronous API that you need to make synchronous, but you can’t modify it.

Apple Developer API Reference also gives the following discussion for DispatchSemaphore init(value:​) initializer:

Passing zero for the value is useful for when two threads need to reconcile the completion of a particular event. Passing a value greater than zero is useful for managing a finite pool of resources, where the pool size is equal to the value.

Usage:

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
The Apple Developer API Reference states about Operation​Queue:

Operation queues use the libdispatch library (also known as Grand Central Dispatch) to initiate the execution of their operations.

Usage:

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
