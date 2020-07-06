class JSSearchView : UIView {

    var searchBar : UISearchBar!

    override func awakeFromNib()
    {
        // the actual search barw
        self.searchBar = UISearchBar(frame: self.frame)

        self.searchBar.clipsToBounds = true

        // the smaller the number in relation to the view, the more subtle
        // the rounding -- https://www.hackingwithswift.com/example-code/calayer/how-to-round-the-corners-of-a-uiview
        self.searchBar.layer.cornerRadius = 5

        self.addSubview(self.searchBar)

        self.searchBar.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20)
        let trailingConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -20)
        let yConstraint = NSLayoutConstraint(item: self.searchBar, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

        self.addConstraints([yConstraint, leadingConstraint, trailingConstraint])

        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.searchBar.tintColor = UIColor.clear
        self.searchBar.isTranslucent = true

        // https://stackoverflow.com/questions/21191801/how-to-add-a-1-pixel-gray-border-around-a-uisearchbar-textfield/21192270
        for s in self.searchBar.subviews[0].subviews {
            if s is UITextField {
                s.layer.borderWidth = 1.0
                s.layer.cornerRadius = 10
                s.layer.borderColor = UIColor.green.cgColor
            }
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // the half height green background you wanted...            
        let topRect = CGRect(origin: .zero, size: CGSize(width: self.frame.size.width, height: (self.frame.height / 2)))
        UIColor.green.set()
        UIRectFill(topRect)
    }
}
