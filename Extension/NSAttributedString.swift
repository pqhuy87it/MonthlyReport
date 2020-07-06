let font = UIFont.systemFont(ofSize: 72)
let paragraphStyle = NSMutableParagraphStyle()
paragraphStyle.alignment = .center
paragraphStyle.firstLineHeadIndent = 5.0

let attributes: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: UIColor.blue,
    .paragraphStyle: paragraphStyle
]

let attributedQuote = NSAttributedString(string: quote, attributes: attributes)

let sentence = "the cat sat on the mat"
let regularAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
let largeAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
let attributedSentence = NSMutableAttributedString(string: sentence, attributes: regularAttributes)

attributedSentence.setAttributes(largeAttributes, range: NSRange(location: 0, length: 3))
attributedSentence.setAttributes(largeAttributes, range: NSRange(location: 8, length: 3))
attributedSentence.setAttributes(largeAttributes, range: NSRange(location: 15, length: 3))

let quote = "Haters gonna hate"
let font = UIFont.systemFont(ofSize: 72)
let attributes = [NSAttributedString.Key.font: font]
let attributedQuote = NSAttributedString(string: quote, attributes: attributes)
