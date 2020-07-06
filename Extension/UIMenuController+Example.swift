import UIKit
class ResponsiveView: UIView {
override var canBecomeFirstResponder: Bool {
return true
    }
}
class ViewController: UIViewController {
var responsiveView: ResponsiveView!
override func viewDidLoad() {
super.viewDidLoad()
        responsiveView = ResponsiveView()
// Add our responsive view to a super view
        responsiveView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        responsiveView.center = self.view.center
        responsiveView.backgroundColor = UIColor(red: 124.0/255.0, green: 112.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        responsiveView.layer.cornerRadius = 4;
        responsiveView.layer.masksToBounds = true
self.view.addSubview(responsiveView)
// Add a long press gesture recognizer to our responsive view
        responsiveView.isUserInteractionEnabled = true
let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
        responsiveView.addGestureRecognizer(longPressGR)
    }
@objc func longPressHandler(sender: UILongPressGestureRecognizer) {
guard sender.state == .began,
let senderView = sender.view,
let superView = sender.view?.superview
else { return }
// Make responsiveView the window's first responder
        senderView.becomeFirstResponder()
// Set up the shared UIMenuController
        let saveMenuItem = UIMenuItem(title: "Save", action: #selector(saveTapped))
let deleteMenuItem = UIMenuItem(title: "Delete", action: #selector(deleteTapped))
        UIMenuController.shared.menuItems = [saveMenuItem, deleteMenuItem]
// Tell the menu controller the first responder's frame and its super view
        UIMenuController.shared.setTargetRect(senderView.frame, in: superView)
// Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
@objc func saveTapped() {
print("save tapped")
// ...
        // This would be a good place to optionally resign
        // responsiveView's first responder status if you need to
        responsiveView.resignFirstResponder()
    }
@objc func deleteTapped() {
print("delete tapped")
// ...
        responsiveView.resignFirstResponder()
    }
}
