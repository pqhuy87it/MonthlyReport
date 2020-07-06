https://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index

let str = "a👿b🇩🇪c"
let r1 = str.range(of: "🇩🇪")!

// String range to NSRange:
let n1 = NSRange(r1, in: str)
print((str as NSString).substring(with: n1)) // 🇩🇪

// NSRange back to String range:
let r2 = Range(n1, in: str)!
print(str[r2]) // 🇩🇪

func textField(_ textField: UITextField,
               shouldChangeCharactersIn range: NSRange,
               replacementString string: String) -> Bool {

    if let oldString = textField.text {
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                      with: string)
        // ...
    }
    // ...
}

--------------------------------------------------------------------------------------

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        return Range(nsRange, in: self)
    }
}
