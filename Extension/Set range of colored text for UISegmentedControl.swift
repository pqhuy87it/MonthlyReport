https://stackoverflow.com/questions/61831978/set-range-of-colored-text-for-uisegmentedcontrol

import UIKit
import PlaygroundSupport

extension UIView {

    class func getAllSubviews<T: UIView>(from parentView: UIView) -> [T] {
        return parentView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func getAllSubviews(from parentView: UIView, types: [UIView.Type]) -> [UIView] {
        return parentView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get<T: UIView>(all type: T.Type) -> [T] { return UIView.getAllSubviews(from: self) as [T] }
    func get(all types: [UIView.Type]) -> [UIView] { return UIView.getAllSubviews(from: self, types: types) }
}

class MyViewController : UIViewController {

    var myString: String = "LDR (I-125)"
    var myString42: String = "424242424242"
    var attributedString = NSMutableAttributedString()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let items = ["EBRT", "LDR (I-125)", "PERM"]
        let modalitySegmentedControl = UISegmentedControl(items: items)
        modalitySegmentedControl.frame = CGRect(x: 20, y: 200, width: 300, height: 20)
        modalitySegmentedControl.backgroundColor = .white

        attributedString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:4, length:7))

        let subviews = modalitySegmentedControl.getAllSubviews()
        for view in subviews {
            if view is UILabel {
                if let label = view as? UILabel, label.text == myString {
                    print(label.attributedText)
                    label.attributedText = attributedString
                    //label.text = "42" // this works
                    print(label.attributedText) // looks changed
                }
            }
        }

        let subviews2 = modalitySegmentedControl.getAllSubviews()
        for view in subviews2 {
            if view is UILabel {
                if let label = view as? UILabel, label.text == myString {
                    print(label.attributedText) // but it didn't change
                }
            }
        }

        let lab = UILabel()
        lab.frame = CGRect(x: 40, y: 250, width: 300, height: 20)
        lab.attributedText = attributedString

        view.addSubview(lab)
        view.addSubview(modalitySegmentedControl)
        self.view = view

    }

}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
