public extension String {
    public var halfWidth: String {
        return transformFullWidthToHalfWidth(reverse: false)
    }

    public var fullWidth: String {
        return transformFullWidthToHalfWidth(reverse: true)
    }

    private func transformFullWidthToHalfWidth(reverse: Bool) -> String {
        let string = NSMutableString(string: self) as CFMutableString
        CFStringTransform(string, nil, kCFStringTransformFullwidthHalfwidth, reverse)
        return string as String
    }
}

let string = "１２3ＡＢcdeあいう"
string.halfWidth //=> "123ABcdeあいう"
string.fullWidth //=> "１２３ＡＢｃｄｅあいう"