https://stackoverflow.com/questions/43561169/trying-to-understand-asynchronous-operation-subclass/48104095#48104095

class ThreadSafeArray<T> {
    private var values: [T]
    private let queue = DispatchQueue(label: "...", attributes: .concurrent)

    init(_ values: [T]) {
        self.values = values
    }

    func reader<U>(block: () throws -> U) rethrows -> U {
        return try queue.sync {
            try block()
        }
    }

    func writer(block: @escaping (inout [T]) -> Void) {
        queue.async(flags: .barrier) {
            block(&self.values)
        }
    }

    // e.g. you might use `reader` and `writer` like the following:

    subscript(_ index: Int) -> T {
        get { reader { values[index] } }
        set { writer { $0[index] = newValue } }
    }

    func append(_ value: T) {
        writer { $0.append(value) }
    }

    func remove(at index: Int) {
        writer { $0.remove(at: index)}
    }
}

public class AsynchronousOperation: Operation {

    /// State for this operation.

    @objc private enum OperationState: Int {
        case ready
        case executing
        case finished
    }

    /// Concurrent queue for synchronizing access to `state`.

    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)

    /// Private backing stored property for `state`.

    private var _state: OperationState = .ready

    /// The state of the operation

    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { _state } }
        set { stateQueue.async(flags: .barrier) { self._state = newValue } }
    }

    // MARK: - Various `Operation` properties

    open         override var isReady:        Bool { return state == .ready && super.isReady }
    public final override var isExecuting:    Bool { return state == .executing }
    public final override var isFinished:     Bool { return state == .finished }
    public final override var isAsynchronous: Bool { return true }

    // KVN for dependent properties

    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }

        return super.keyPathsForValuesAffectingValue(forKey: key)
    }

    // Start

    public final override func start() {
        if isCancelled {
            state = .finished
            return
        }

        state = .executing

        main()
    }

    /// Subclasses must implement this to perform their work and they must not call `super`. The default implementation of this function throws an exception.

    open override func main() {
        fatalError("Subclasses must implement `main`.")
    }

    /// Call this function to finish an operation that is currently executing

    public final func finish() {
        if !isFinished { state = .finished }
    }
}
