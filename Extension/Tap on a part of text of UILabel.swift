// https://stackoverflow.com/questions/36043006/swift-tap-on-a-part-of-text-of-uilabel

let text = "Please agree for Terms & Conditions."
lblTerms.text = text
self.lblTerms.textColor =  UIColor.white
let underlineAttriString = NSMutableAttributedString(string: text)
let range1 = (text as NSString).range(of: "Terms & Conditions.")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: Theme.Font.Regular, size: Theme.Font.size.lblSize)!, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.color.primaryGreen, range: range1)
lblTerms.attributedText = underlineAttriString
lblTerms.isUserInteractionEnabled = true
lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))

@IBAction func tapLabel(gesture: UITapGestureRecognizer) {
   let termsRange = (text as NSString).range(of: "Terms & Conditions")
   // comment for now
   //let privacyRange = (text as NSString).range(of: "Privacy Policy")

   if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: termsRange) {
       print("Tapped terms")
   } else if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: privacyRange) {
       print("Tapped privacy") 
   } else {                
       print("Tapped none")
   }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
