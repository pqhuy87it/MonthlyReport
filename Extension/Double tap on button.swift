@IBOutlet weak var button: UIButton!

override func viewDidLoad() {
    super.viewDidLoad()

    button.addTarget(self, action: "didTap:", forControlEvents: .TouchUpInside)
    button.addTarget(self, action: "didDoubleTap:", forControlEvents: .TouchDownRepeat)

}

var ignoreTap = false
func didTap(sender: UIButton) {
    if ignoreTap {
        ignoreTap = false
        print("ignoretap", sender)
        return
    }
    print("didTap", sender)
}

func didDoubleTap(sender: UIButton) {
    ignoreTap = true
    print("didDoubleTap", sender)
}
