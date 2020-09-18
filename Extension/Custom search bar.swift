// Change placeholder color
let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.greenColor(), NSFontAttributeName: UIFont.systemFontOfSize(UIFont.systemFontSize())]
let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search", attributes: placeholderAttributes)
let textFieldPlaceHolder = searchBarCustom.valueForKey("searchField") as? UITextField
textFieldPlaceHolder?.attributedPlaceholder = attributedPlaceholder

let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.blueColor(), NSFontAttributeName: UIFont.systemFontOfSize(UIFont.systemFontSize())]
let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search", attributes: placeholderAttributes)
UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).attributedPlaceholder = attributedPlaceholder

// Change textColor of  Search TextField 
extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
}

searchBarCustom.setSerchTextcolor(UIColor.redColor())

let textFieldInsideSearchBar = searchBarCustom.valueForKey("searchField") as? UITextField
textFieldInsideSearchBar?.textColor = UIColor.orangeColor()

KeyPath   : searchField.textColor
Type         : Color
Value       : RGB value from color Picker
