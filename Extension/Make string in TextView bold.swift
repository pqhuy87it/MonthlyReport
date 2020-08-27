https://stackoverflow.com/questions/59589685/swift-search-strings-in-textview-and-make-them-bold

extension UITextView {    
    func makeBold(originalText: String, boldText: String) {

        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let boldRange = attributedOriginalText.mutableString.range(of: boldText)

        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 13), range: boldRange)
        self.attributedText = attributedOriginalText
    }
}

How to use:

@IBOutlet weak var textView: UITextView!

textView.makeBold(originalText: "Make bold", boldText: "bold")
