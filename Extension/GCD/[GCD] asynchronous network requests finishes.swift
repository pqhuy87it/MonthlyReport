https://stackoverflow.com/questions/35906568/wait-until-swift-for-loop-with-asynchronous-network-requests-finishes-executing

override func viewDidLoad() {
    super.viewDidLoad()

    let myGroup = DispatchGroup()

    for i in 0 ..< 5 {
        myGroup.enter()

        Alamofire.request("https://httpbin.org/get", parameters: ["foo": "bar"]).responseJSON { response in
            print("Finished request \(i)")
            myGroup.leave()
        }
    }

    myGroup.notify(queue: .main) {
        print("Finished all requests.")
    }
}

--------------------------------------------------------------------------------------------------------

import Foundation

class SimultaneousOperationsQueue {
    typealias CompleteClosure = ()->()

    private let dispatchQueue: DispatchQueue
    private lazy var tasksCompletionQueue = DispatchQueue.main
    private let semaphore: DispatchSemaphore
    var whenCompleteAll: (()->())?
    private lazy var numberOfPendingActionsSemaphore = DispatchSemaphore(value: 1)
    private lazy var _numberOfPendingActions = 0

    var numberOfPendingTasks: Int {
        get {
            numberOfPendingActionsSemaphore.wait()
            defer { numberOfPendingActionsSemaphore.signal() }
            return _numberOfPendingActions
        }
        set(value) {
            numberOfPendingActionsSemaphore.wait()
            defer { numberOfPendingActionsSemaphore.signal() }
            _numberOfPendingActions = value
        }
    }

    init(numberOfSimultaneousActions: Int, dispatchQueueLabel: String) {
        dispatchQueue = DispatchQueue(label: dispatchQueueLabel)
        semaphore = DispatchSemaphore(value: numberOfSimultaneousActions)
    }

    func run(closure: ((@escaping CompleteClosure) -> Void)?) {
        numberOfPendingTasks += 1
        dispatchQueue.async { [weak self] in
            guard   let self = self,
                    let closure = closure else { return }
            self.semaphore.wait()
            closure {
                defer { self.semaphore.signal() }
                self.numberOfPendingTasks -= 1
                if self.numberOfPendingTasks == 0, let closure = self.whenCompleteAll {
                    self.tasksCompletionQueue.async { closure() }
                }
            }
        }
    }

    func run(closure: (() -> Void)?) {
        numberOfPendingTasks += 1
        dispatchQueue.async { [weak self] in
            guard   let self = self,
                    let closure = closure else { return }
            self.semaphore.wait(); defer { self.semaphore.signal() }
            closure()
            self.numberOfPendingTasks -= 1
            if self.numberOfPendingTasks == 0, let closure = self.whenCompleteAll {
                self.tasksCompletionQueue.async { closure() }
            }
        }
    }
}

let queue = SimultaneousOperationsQueue(numberOfSimultaneousActions: 1, dispatchQueueLabel: "AnyString")
queue.whenCompleteAll = { print("All Done") }

 // add task with sync/async code
queue.run { completeClosure in
    // your code here...

    // Make signal that this closure finished
    completeClosure()
}

 // add task only with sync code
queue.run {
    // your code here...
}


import UIKit

class ViewController: UIViewController {

    private lazy var queue = { SimultaneousOperationsQueue(numberOfSimultaneousActions: 1,
                                                           dispatchQueueLabel: "AnyString") }()
    private weak var button: UIButton!
    private weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 50, y: 80, width: 100, height: 100))
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.numberOfLines = 0
        view.addSubview(button)
        self.button = button

        let label = UILabel(frame: CGRect(x: 180, y: 50, width: 100, height: 100))
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .natural
        view.addSubview(label)
        self.label = label

        queue.whenCompleteAll = { [weak self] in self?.label.text = "All tasks completed" }

        //sample1()
        sample2()
    }

    func sample1() {
        button.setTitle("Run 2 task", for: .normal)
        button.addTarget(self, action: #selector(sample1Action), for: .touchUpInside)
    }

    func sample2() {
        button.setTitle("Run 10 tasks", for: .normal)
        button.addTarget(self, action: #selector(sample2Action), for: .touchUpInside)
    }

    private func add2Tasks() {
        queue.run { completeTask in
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.label.text = "pending tasks \(self.queue.numberOfPendingTasks)"
                }
                completeTask()
            }
        }
        queue.run {
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.label.text = "pending tasks \(self.queue.numberOfPendingTasks)"
            }
        }
    }

    @objc func sample1Action() {
        label.text = "pending tasks \(queue.numberOfPendingTasks)"
        add2Tasks()
    }

    @objc func sample2Action() {
        label.text = "pending tasks \(queue.numberOfPendingTasks)"
        for _ in 0..<5 { add2Tasks() }
    }
}
