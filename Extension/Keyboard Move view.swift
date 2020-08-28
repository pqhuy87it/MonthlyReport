https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift

https://github.com/MengTo/Spring/blob/master/Spring/KeyboardLayoutConstraint.swift

override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)            
    }   

func keyboardWillShow(notification: NSNotification) {            
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
        self.view.frame.origin.y -= keyboardSize.height
    }            
}

func keyboardWillHide(notification: NSNotification) {
    self.view.frame.origin.y = 0
}

func keyboardWillShow(notification: NSNotification) {        
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }        
}

func keyboardWillHide(notification: NSNotification) {
    if view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
    }
}

EDIT FOR SWIFT 4.2:

override func viewDidLoad() {
    super.viewDidLoad()            
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
}

@objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
}

@objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
    }
}
