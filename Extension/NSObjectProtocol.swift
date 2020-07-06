public extension NSObjectProtocol {
    public var describedProperty: String {
        let mirror = Mirror(reflecting: self)
        return mirror.children.map { element -> String in
            let key = element.label ?? "Unknown"
            let value = element.value
            return "\(key): \(value)"
        }
        .joined(separator: "\n")
    }
}

class Hoge: NSObject {
    var foo = 1
    let bar = "bar"
   }
}

Hoge().described // => "foo: 1\nbar: bar"