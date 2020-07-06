public extension Array where Element: Equatable {
    @discardableResult
    public mutating func remove(element: Element) -> Index? {
        guard let index = index(of: element) else { return nil }
        remove(at: index)
        return index
    }

    @discardableResult
    public mutating func remove(elements: [Element]) -> [Index] {
        return elements.flatMap { remove(element: $0) }
    }
}

// swift 5
public extension Array where Element: Equatable {
    @discardableResult
	mutating func remove(_ element: Element) -> Index? {
		guard let index = firstIndex(of: element) else { return nil }
        remove(at: index)
        return index
    }

    @discardableResult
	mutating func remove(_ elements: [Element]) -> [Index] {
		return elements.compactMap { remove($0) }
    }
}

let array = ["foo", "bar"]
array.remove(element: "foo")
array //=> ["bar"]


public extension Array where Element: Hashable {
    public mutating func unify() {
        self = unified()
    }
}

public extension Collection where Element: Hashable {
    public func unified() -> [Element] {
        return reduce(into: []) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
}

let array = [1, 2, 3, 3, 2, 1, 4]
array.unify() // [1, 2, 3, 4]
