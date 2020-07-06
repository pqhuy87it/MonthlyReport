public extension Collection {
    public subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}

let array = [0, 1, 2]
if let item = array[safe: 5] {
    print("unreachable")
}