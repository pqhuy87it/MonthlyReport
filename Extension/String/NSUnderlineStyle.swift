https://qiita.com/m_orishi/items/ce65d60ea9b47bfcddf3

override func viewDidLoad() {
    super.viewDidLoad()

    let single = NSUnderlineStyle.styleSingle.rawValue
    let thick = NSUnderlineStyle.styleThick.rawValue
    let double = NSUnderlineStyle.styleDouble.rawValue

    let dot = NSUnderlineStyle.patternDot.rawValue
    let dash = NSUnderlineStyle.patternDash.rawValue
    let dashDot = NSUnderlineStyle.patternDashDot.rawValue
    let dashDotDot = NSUnderlineStyle.patternDashDotDot.rawValue

    let word = NSUnderlineStyle.byWord.rawValue

    addUnderLine(label: singleDot, setValue: single | dot)
    addUnderLine(label: singleDash, setValue: single | dash)
    addUnderLine(label: singleDashDot, setValue: single | dashDot)
    addUnderLine(label: singleDashDotDot, setValue: single | dashDotDot)

    addUnderLine(label: thickDot, setValue: thick | dot)
    addUnderLine(label: thickDash, setValue: thick | dash)
    addUnderLine(label: thickDashDot, setValue: thick | dashDot)
    addUnderLine(label: thickDashDotDot, setValue: thick | dashDotDot)

    addUnderLine(label: doubleDot, setValue: double | dot)
    addUnderLine(label: doubleDash, setValue: double | dash)
    addUnderLine(label: doubleDashDot, setValue: double | dashDot)
    addUnderLine(label: doubleDashDotDot, setValue: double | dashDotDot)

    addUnderLine(label: byWord, setValue: thick | word)
}

private func addUnderLine(label: UILabel, setValue: Int) {
    let attributeText = NSMutableAttributedString(string: label.text!)
    attributeText.addAttribute(.underlineStyle, value: setValue, range: NSMakeRange(0, label.text!.count))
    label.attributedText = attributeText
}

![](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F165931%2Ff0fa11fb-fa45-8e3a-8877-c3b73068ad0d.png?ixlib=rb-1.2.2&auto=format&gif-q=60&q=75&w=1400&fit=max&s=6b7d09b50696655e77d4f7d8b6a1ee0e)
