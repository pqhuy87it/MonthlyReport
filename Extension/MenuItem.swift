override func viewDidLoad() {
       super.viewDidLoad()

       let myMenuController: UIMenuController = UIMenuController.sharedMenuController()

       // MenuItem生成.
       let myMenuItem_1: UIMenuItem = UIMenuItem(title: "Menu1", action: "onMenu1:")
       let myMenuItem_2: UIMenuItem = UIMenuItem(title: "Menu2", action: "onMenu2:")
       let myMenuItem_3: UIMenuItem = UIMenuItem(title: "Menu3", action: "onMenu3:")

       // MenuItemを配列に格納.
       let myMenuItems: NSArray = [myMenuItem_1, myMenuItem_2, myMenuItem_3]

       // MenuControllerにMenuItemを追加.
       myMenuController.menuItems = myMenuItems as [AnyObject]
}

override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if action == "onMenu1:" || action == "onMenu2:" || action == "Menu3:" {
            return true
        }
        return false
}

/*
作成したMenuItemが押された際に呼び出される.
*/
internal func onMenu1(sender: UIMenuItem) {
        println("onMenu1")
}

internal func onMenu2(sender: UIMenuItem) {
        println("onMenu2")
}

internal func onMenu3(sender: UIMenuItem) {
        println("onMenu3")
}
