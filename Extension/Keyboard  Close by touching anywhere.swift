https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift

verride func viewDidLoad() {
    super.viewDidLoad()

    //Looks for single or multiple taps. 
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false 

    view.addGestureRecognizer(tap)
}

//Calls this function when the tap is recognized.
@objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
}

----

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false            
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround() 
}
