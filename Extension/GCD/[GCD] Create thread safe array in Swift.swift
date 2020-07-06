https://stackoverflow.com/questions/28191079/create-thread-safe-array-in-swift

https://basememara.com/creating-thread-safe-arrays-in-swift/

public class ThreadSafeArray<Element> {

    private var elements    : [Element]
    private let syncQueue   = DispatchQueue(label: "Sync Queue",
                                            qos: .default,
                                            attributes: .concurrent,
                                            autoreleaseFrequency: .inherit,
                                            target: nil)

    public init() {
        elements = []
    }

    public init(_ newElements: [Element]) {
        elements = newElements
    }

    //MARK: Non-mutating

    public var first : Element? {
        return syncQueue.sync {
            elements.first
        }
    }

    public var last : Element? {
        return syncQueue.sync {
            elements.last
        }
    }

    public var count : Int {

        return syncQueue.sync {
            elements.count
        }
    }

    public subscript(index: Int) -> Element {

        get {
            return syncQueue.sync {
                elements[index]
            }
        }

        set {
            syncQueue.sync(flags: .barrier) {
                elements[index] = newValue
            }
        }
    }

    public func reversed() -> [Element] {

        return syncQueue.sync {

            elements.reversed()
        }
    }

    public func flatMap<T>(_ transform: (Element) throws -> T?) rethrows -> [T]  {

        return try syncQueue.sync {

           try elements.flatMap(transform)
        }
    }

    public func filter(_ isIncluded: (Element) -> Bool) -> [Element] {

        return syncQueue.sync {

            elements.filter(isIncluded)
        }
    }

    //MARK: Mutating

    public func append(_ element: Element) {

        syncQueue.sync(flags: .barrier) {

            elements.append(element)
        }
    }

    public func append<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence {

        syncQueue.sync(flags: .barrier) {

            elements.append(contentsOf: newElements)
        }
    }

    public func remove(at index: Int) -> Element? {

        var element : Element?

        syncQueue.sync(flags: .barrier) {

            if elements.startIndex ..< elements.endIndex ~= index {
                element = elements.remove(at: index)
            }
            else {
                element = nil
            }
        }

        return element
    }
}

extension ThreadSafeArray where Element : Equatable {

    public func index(of element: Element) -> Int? {

        return syncQueue.sync {
            elements.index(of: element)
        }
    }
}


--------------------------------------------------------------------------------

import Foundation

// https://developer.apple.com/documentation/swift/rangereplaceablecollection
struct AtomicArray<T>: RangeReplaceableCollection {

    typealias Element = T
    typealias Index = Int
    typealias SubSequence = AtomicArray<T>
    typealias Indices = Range<Int>
    fileprivate var array: Array<T>
    var startIndex: Int { return array.startIndex }
    var endIndex: Int { return array.endIndex }
    var indices: Range<Int> { return array.indices }

    func index(after i: Int) -> Int { return array.index(after: i) }

    private var semaphore = DispatchSemaphore(value: 1)
    fileprivate func _wait() { semaphore.wait() }
    fileprivate func _signal() { semaphore.signal() }
}

// MARK: - Instance Methods

extension AtomicArray {

    init<S>(_ elements: S) where S : Sequence, AtomicArray.Element == S.Element {
        array = Array<S.Element>(elements)
    }

    init() { self.init([]) }

    init(repeating repeatedValue: AtomicArray.Element, count: Int) {
        let array = Array(repeating: repeatedValue, count: count)
        self.init(array)
    }
}

// MARK: - Instance Methods

extension AtomicArray {

    public mutating func append(_ newElement: AtomicArray.Element) {
        _wait(); defer { _signal() }
        array.append(newElement)
    }

    public mutating func append<S>(contentsOf newElements: S) where S : Sequence, AtomicArray.Element == S.Element {
        _wait(); defer { _signal() }
        array.append(contentsOf: newElements)
    }

    func filter(_ isIncluded: (AtomicArray.Element) throws -> Bool) rethrows -> AtomicArray {
        _wait(); defer { _signal() }
        let subArray = try array.filter(isIncluded)
        return AtomicArray(subArray)
    }

    public mutating func insert(_ newElement: AtomicArray.Element, at i: AtomicArray.Index) {
        _wait(); defer { _signal() }
        array.insert(newElement, at: i)
    }

    mutating func insert<S>(contentsOf newElements: S, at i: AtomicArray.Index) where S : Collection, AtomicArray.Element == S.Element {
        _wait(); defer { _signal() }
        array.insert(contentsOf: newElements, at: i)
    }

    mutating func popLast() -> AtomicArray.Element? {
        _wait(); defer { _signal() }
        return array.popLast()
    }

    @discardableResult mutating func remove(at i: AtomicArray.Index) -> AtomicArray.Element {
        _wait(); defer { _signal() }
        return array.remove(at: i)
    }

    mutating func removeAll() {
        _wait(); defer { _signal() }
        array.removeAll()
    }

    mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        _wait(); defer { _signal() }
        array.removeAll()
    }

    mutating func removeAll(where shouldBeRemoved: (AtomicArray.Element) throws -> Bool) rethrows {
        _wait(); defer { _signal() }
        try array.removeAll(where: shouldBeRemoved)
    }

    @discardableResult mutating func removeFirst() -> AtomicArray.Element {
        _wait(); defer { _signal() }
        return array.removeFirst()
    }

    mutating func removeFirst(_ k: Int) {
        _wait(); defer { _signal() }
        array.removeFirst(k)
    }

    @discardableResult mutating func removeLast() -> AtomicArray.Element {
        _wait(); defer { _signal() }
        return array.removeLast()
    }

    mutating func removeLast(_ k: Int) {
        _wait(); defer { _signal() }
        array.removeLast(k)
    }

    @inlinable public func forEach(_ body: (Element) throws -> Void) rethrows {
        _wait(); defer { _signal() }
        try array.forEach(body)
    }

    mutating func removeFirstIfExist(where shouldBeRemoved: (AtomicArray.Element) throws -> Bool) {
        _wait(); defer { _signal() }
        guard let index = try? array.firstIndex(where: shouldBeRemoved) else { return }
        array.remove(at: index)
    }

    mutating func removeSubrange(_ bounds: Range<Int>) {
        _wait(); defer { _signal() }
        array.removeSubrange(bounds)
    }

    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, T == C.Element, AtomicArray<Element>.Index == R.Bound {
        _wait(); defer { _signal() }
        array.replaceSubrange(subrange, with: newElements)
    }

    mutating func reserveCapacity(_ n: Int) {
        _wait(); defer { _signal() }
        array.reserveCapacity(n)
    }

    public var count: Int {
        _wait(); defer { _signal() }
        return array.count
    }

    public var isEmpty: Bool {
        _wait(); defer { _signal() }
        return array.isEmpty
    }
}

// MARK: - Get/Set

extension AtomicArray {

    // Single  action

    func get() -> [T] {
        _wait(); defer { _signal() }
        return array
    }

    mutating func set(array: [T]) {
        _wait(); defer { _signal() }
        self.array = array
    }

    // Multy actions

    mutating func get(closure: ([T])->()) {
        _wait(); defer { _signal() }
        closure(array)
    }

    mutating func set(closure: ([T]) -> ([T])) {
        _wait(); defer { _signal() }
        array = closure(array)
    }
}

// MARK: - Subscripts

extension AtomicArray {

    subscript(bounds: Range<AtomicArray.Index>) -> AtomicArray.SubSequence {
        get {
            _wait(); defer { _signal() }
            return AtomicArray(array[bounds])
        }
    }

    subscript(bounds: AtomicArray.Index) -> AtomicArray.Element {
        get {
            _wait(); defer { _signal() }
            return array[bounds]
        }
        set(value) {
            _wait(); defer { _signal() }
            array[bounds] = value
        }
    }
}

// MARK: - Operator Functions

extension AtomicArray {

    static func + <Other>(lhs: Other, rhs: AtomicArray) -> AtomicArray where Other : Sequence, AtomicArray.Element == Other.Element {
        return AtomicArray(lhs + rhs.get())
    }

    static func + <Other>(lhs: AtomicArray, rhs: Other) -> AtomicArray where Other : Sequence, AtomicArray.Element == Other.Element {
        return AtomicArray(lhs.get() + rhs)
    }

    static func + <Other>(lhs: AtomicArray, rhs: Other) -> AtomicArray where Other : RangeReplaceableCollection, AtomicArray.Element == Other.Element {
        return AtomicArray(lhs.get() + rhs)
    }

    static func + (lhs: AtomicArray<Element>, rhs: AtomicArray<Element>) -> AtomicArray {
        return AtomicArray(lhs.get() + rhs.get())
    }

    static func += <Other>(lhs: inout AtomicArray, rhs: Other) where Other : Sequence, AtomicArray.Element == Other.Element {
        lhs._wait(); defer { lhs._signal() }
        lhs.array += rhs
    }
}

// MARK: - CustomStringConvertible

extension AtomicArray: CustomStringConvertible {
    var description: String {
        _wait(); defer { _signal() }
        return "\(array)"
    }
}

// MARK: - Equatable

extension AtomicArray where Element : Equatable {

    func split(separator: Element, maxSplits: Int, omittingEmptySubsequences: Bool) -> [ArraySlice<Element>] {
        _wait(); defer { _signal() }
        return array.split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences)
    }

    func firstIndex(of element: Element) -> Int? {
        _wait(); defer { _signal() }
        return array.firstIndex(of: element)
    }

    func lastIndex(of element: Element) -> Int? {
        _wait(); defer { _signal() }
        return array.lastIndex(of: element)
    }

    func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, Element == PossiblePrefix.Element {
        _wait(); defer { _signal() }
        return array.starts(with: possiblePrefix)
    }

    func elementsEqual<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, Element == OtherSequence.Element {
        _wait(); defer { _signal() }
        return array.elementsEqual(other)
    }

    func contains(_ element: Element) -> Bool {
        _wait(); defer { _signal() }
        return array.contains(element)
    }

    static func != (lhs: AtomicArray<Element>, rhs: AtomicArray<Element>) -> Bool {
        lhs._wait(); defer { lhs._signal() }
        rhs._wait(); defer { rhs._signal() }
        return lhs.array != rhs.array
    }

    static func == (lhs: AtomicArray<Element>, rhs: AtomicArray<Element>) -> Bool {
        lhs._wait(); defer { lhs._signal() }
        rhs._wait(); defer { rhs._signal() }
        return lhs.array == rhs.array
    }
}

// Usage sample 1
import Foundation

// init
var array = AtomicArray<Int>()
print(array)
array = AtomicArray(repeating: 0, count: 5)
print(array)
array = AtomicArray([1,2,3,4,5,6,7,8,9])
print(array)

// add
array.append(0)
print(array)
array.append(contentsOf: [5,5,5])
print(array)

// filter
array = array.filter { $0 < 7 }
print(array)

// map
let strings = array.map { "\($0)" }
print(strings)

// insert
array.insert(99, at: 5)
print(array)
array.insert(contentsOf: [2, 2, 2], at: 0)
print(array)

// pop
_ = array.popLast()
print(array)
_ = array.popFirst()
print(array)

// remove
array.removeFirst()
print(array)
array.removeFirst(3)
print(array)
array.remove(at: 2)
print(array)
array.removeLast()
print(array)
array.removeLast(5)
print(array)
array.removeAll { $0%2 == 0 }
print(array)
array = AtomicArray([1,2,3,4,5,6,7,8,9,0])
array.removeSubrange(0...2)
print(array)
array.replaceSubrange(0...2, with: [0,0,0])
print(array)
array.removeAll()
print(array)

array.set(array: [1,2,3,4,5,6,7,8,9,0])
print(array)

// subscript
print(array[0])
array[0] = 100
print(array)
print(array[1...4])

// operator functions
array = [1,2,3] + AtomicArray([4,5,6])
print(array)
array = AtomicArray([4,5,6]) + [1,2,3]
print(array)
array = AtomicArray([1,2,3]) + AtomicArray([4,5,6])
print(array)

// Usage sample 2

import Foundation

var arr = AtomicArray([0,1,2,3,4,5])
for i in 0...1000 {
    // Single actions
    DispatchQueue.global(qos: .background).async {
        usleep(useconds_t(Int.random(in: 100...10000)))
        let num = i*i
        arr.append(num)
        print("arr.append(\(num)), background queue")
    }
    DispatchQueue.global(qos: .default).async {
        usleep(useconds_t(Int.random(in: 100...10000)))
        arr.append(arr.count)
        print("arr.append(\(arr.count)), default queue")
    }

    // multy actions
    DispatchQueue.global(qos: .utility).async {
        arr.set { array -> [Int] in
            var newArray = array
            newArray.sort()
            print("sort(), .utility queue")
            return newArray
        }
    }
}
