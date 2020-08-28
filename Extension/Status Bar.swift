https://stackoverflow.com/questions/17678881/how-to-change-status-bar-text-color-in-ios?page=1&tab=votes#tab-top

https://sarunw.com/posts/how-to-set-status-bar-style/

https://medium.com/@craiggrummitt/the-mysterious-case-of-the-status-bar-d9059a327c97

Open you Info.plist.
Add View controller-based status bar appearance key (UIViewControllerBasedStatusBarAppearance) and set value to No (false).
Add Status bar style key (UIStatusBarStyle) and set value to Light Content (UIStatusBarStyleLightContent).

Style based on condition #

If you need to change the status bar style dynamically, e.g., you want it to change based on the scrollable content, you can do that with the same property, preferredStatusBarStyle.

var preferredStatusBarStyle: UIStatusBarStyle
Since preferredStatusBarStyle is a get-only property, you can't set the style directly, but you can control it with a help of simple variable and setNeedsStatusBarAppearanceUpdate() method.

var isDarkContentBackground = false // <1>

func statusBarEnterLightBackground() { // <2>
    isDarkContentBackground = false
    setNeedsStatusBarAppearanceUpdate()
}

func statusBarEnterDarkBackground() { // <3>
    isDarkContentBackground = true
    setNeedsStatusBarAppearanceUpdate() <4>
}

override var preferredStatusBarStyle: UIStatusBarStyle {
    if isDarkContentBackground { // <5>
        return .lightContent
    } else {
        return .darkContent
    }
}
<1> We declare a new variable to dictate current background color.
<2> A function to call when scrollable content under status bar become ligth. We simply set isDarkContentBackground to false.
<3> A function to call when scrollable content under status bar become dark. We set isDarkContentBackground to true.
<4> You need to call setNeedsStatusBarAppearanceUpdate() to notify the system that the value from preferredStatusBarStyle has changed.
<5> We return a status bar style based on isDarkContentBackground value.

