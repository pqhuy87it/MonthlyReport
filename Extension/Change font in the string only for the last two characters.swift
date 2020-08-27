https://stackoverflow.com/questions/59792717/how-to-change-font-in-the-string-only-for-the-last-two-characters

![](https://i.stack.imgur.com/mYgGQ.png)

extension String {
    func attributedStringWithColorSize( color: UIColor, size:CGFloat = 12) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)


        if self.count < 3 {
            return attributedString
        }
            let range = NSRange(location: self.count-2, length: 2)
            attributedString.addAttribute(NSAttributedString.Key.font,value: UIFont.systemFont(ofSize: size) , range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

        return attributedString
    }
}

Use like this

@IBOutlet weak var lab: UILabel!
    override func viewDidLoad() {

        lab.attributedText = "1.1470".attributedStringWithColorSize(color: UIColor.red , size: 15)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
