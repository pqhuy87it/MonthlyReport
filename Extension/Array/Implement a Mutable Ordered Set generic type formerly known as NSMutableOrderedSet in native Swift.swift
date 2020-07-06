https://stackoverflow.com/questions/59887561/how-to-implement-a-mutable-ordered-set-generic-type-formerly-known-as-nsmutableo

public protocol OrderedSetProtocol: MutableCollection,
                                    RandomAccessCollection,
                                    SetAlgebra,
                                    AdditiveArithmetic,
                                    RangeReplaceableCollection
                                    where Element: Hashable, Index == Int { }

public struct OrderedSet<Element: Hashable>: OrderedSetProtocol {
    public init() { }
    private var elements: [Element] = []
    private var set: Set<Element> = []
}

extension OrderedSet: MutableCollection {
    public subscript(index: Index) -> Element {
        get { elements[index] }
        set {
            guard set.update(with: newValue) == nil else {
                //
                // needs some implementation before returning
                // insert(remove(at: elements.firstIndex(of: newValue)!), at: index)
                //
                return 
            }
            elements[index] = newValue
        }
    }
}

extension OrderedSet: RandomAccessCollection {

    public typealias Index = Int
    public typealias Indices = Range<Int>

    public typealias SubSequence = Slice<OrderedSet<Element>>
    public typealias Iterator = IndexingIterator<Self>

    // Generic subscript to support `PartialRangeThrough`, `PartialRangeUpTo`, `PartialRangeFrom` 
    public subscript<R: RangeExpression>(range: R) -> SubSequence where Index == R.Bound { .init(base: self, bounds: range.relative(to: self)) }

    public var endIndex: Index { elements.endIndex }
    public var startIndex: Index { elements.startIndex }

    public func formIndex(after i: inout Index) { elements.formIndex(after: &i) }

    public var isEmpty: Bool { elements.isEmpty }

    @discardableResult
    public mutating func append(_ newElement: Element) -> Bool { insert(newElement).inserted }
}

extension OrderedSet: Hashable {
    public static func ==(lhs: Self, rhs: Self) -> Bool { lhs.elements.elementsEqual(rhs.elements) }
}

extension OrderedSet: SetAlgebra {
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let insertion = set.insert(newMember)
        if insertion.inserted { elements.append(newMember) }
        return insertion
    }
    public mutating func remove(_ member: Element) -> Element? {
        if let index = elements.firstIndex(of: member) {
            elements.remove(at: index)
            return set.remove(member)
        }
        return nil
    }
    public mutating func update(with newMember: Element) -> Element? {
        if let index = elements.firstIndex(of: newMember) {
            elements[index] = newMember
            return set.update(with: newMember)
        } else {
            elements.append(newMember)
            set.insert(newMember)
            return nil
        }
    }

    public func union(_ other: Self) -> Self {
        var orderedSet = self
        orderedSet.formUnion(other)
        return orderedSet
    }
    public func intersection(_ other: Self) -> Self { filter(other.contains) }
    public func symmetricDifference(_ other: Self) -> Self { filter { !other.set.contains($0) } + other.filter { !set.contains($0) } }

    public mutating func formUnion(_ other: Self) { other.forEach { self.append($0) } }
    public mutating func formIntersection(_ other: Self) { self = intersection(other) }
    public mutating func formSymmetricDifference(_ other: Self) { self = symmetricDifference(other) }
}

extension OrderedSet: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element
    public init(arrayLiteral: Element...) {
        self.init()
        for element in arrayLiteral {
            self.append(element)
        }
    }
}

extension OrderedSet: AdditiveArithmetic {
    public static var zero: Self { .init() }
    public static func + (lhs: Self, rhs: Self) -> Self { lhs.union(rhs) }
    public static func - (lhs: Self, rhs: Self) -> Self { lhs.subtracting(rhs) }
    public static func += (lhs: inout Self, rhs: Self) { lhs.formUnion(rhs) }
    public static func -= (lhs: inout Self, rhs: Self) { lhs.subtract(rhs) }
}

extension OrderedSet: RangeReplaceableCollection {

    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        elements.forEach { set.insert($0).inserted ? self.elements.append($0) : () }
    }

    mutating public func replaceSubrange<C: Collection, R: RangeExpression>(_ subrange: R, with newElements: C) where Element == C.Element, C.Element: Hashable, Index == R.Bound {
        elements[subrange].forEach { set.remove($0) }
        elements.removeSubrange(subrange)
        var index = subrange.relative(to: self).lowerBound
        newElements.forEach {
            if set.insert($0).inserted {
                elements.insert($0, at: index)
                formIndex(after: &index)
            }
        }
    }
    
extension OrderedSet: CustomStringConvertible {
    public var description: String { .init(describing: elements) }
}

extension Slice: CustomStringConvertible where Base: OrderedSetProtocol {
    public var description: String {
        var description = "["
        var first = true
        for element in self {
            if first {
                first = false
            } else {
                description += ", "
            }
            debugPrint(element, terminator: "", to: &description)
        }
        return description + "]"
    }
}

var ordereSet1: OrderedSet = [1,2,3,4,5,6,1,2,3]  // [1, 2, 3, 4, 5, 6]
var ordereSet2: OrderedSet = [4,5,6,7,8,9,7,8,9]  // [4, 5, 6, 7, 8, 9]

ordereSet1 == ordereSet2                          // false
ordereSet1.union(ordereSet2)                      // [1, 2, 3, 4, 5, 6, 7, 8, 9]

ordereSet1.intersection(ordereSet2)               // [4, 5, 6]
ordereSet1.symmetricDifference(ordereSet2)        // [1, 2, 3, 7, 8, 9]

ordereSet1.subtract(ordereSet2)                   // [1, 2, 3]
ordereSet1.insert(contentsOf: [1,3,4,6], at: 0)   // [4, 6, 1, 2, 3]

ordereSet2.popLast()      
