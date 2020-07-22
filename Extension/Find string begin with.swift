// https://stackoverflow.com/questions/32664543/swift-startswith-method

extension String {
    func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        return lowercased().hasPrefix(prefix.lowercased())
    }
}
or:

extension String {
    func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        return lowercased().starts(with: prefix.lowercased())
    }
}
note: for an empty prefix "" both implementations will return true

using Foundation range(of:options:)

extension String {
    func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        return range(of: prefix, options: [.anchored, .caseInsensitive]) != nil
    }
}
note: for an empty prefix "" it will return false

and being ugly with a regex (I've seen it...)

extension String {
    func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        guard let expression = try? NSRegularExpression(pattern: "\(prefix)", options: [.caseInsensitive, .ignoreMetacharacters]) else {
            return false
        }
        return expression.firstMatch(in: self, options: .anchored, range: NSRange(location: 0, length: characters.count)) != nil
    }
}
