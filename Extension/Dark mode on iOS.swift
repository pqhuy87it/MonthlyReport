https://stackoverflow.com/questions/56537855/is-it-possible-to-opt-out-of-dark-mode-on-ios-13

<key>UIUserInterfaceStyle</key>
<string>Light</string>

---

override func viewDidLoad() {
    super.viewDidLoad()
    // overrideUserInterfaceStyle is available with iOS 13
    if #available(iOS 13.0, *) {
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .light
    }
}
