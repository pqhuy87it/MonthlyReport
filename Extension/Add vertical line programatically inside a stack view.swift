https://stackoverflow.com/questions/44098314/ios-add-vertical-line-programatically-inside-a-stack-view

import UIKit
import PlaygroundSupport

extension UIFont {
  var withSmallCaps: UIFont {
    let feature: [UIFontDescriptor.FeatureKey: Any] = [
      UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
      UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector]
    let attributes: [UIFontDescriptor.AttributeName: Any] = [UIFontDescriptor.AttributeName.featureSettings: [feature]]
    let descriptor = self.fontDescriptor.addingAttributes(attributes)
    return UIFont(descriptor: descriptor, size: pointSize)
  }
}

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
rootView.backgroundColor = .white
PlaygroundPage.current.liveView = rootView

let stackView = UIStackView()
stackView.axis = .horizontal
stackView.alignment = .center
stackView.frame = rootView.bounds
rootView.addSubview(stackView)

typealias Item = (name: String, value: Int)
let items: [Item] = [
  Item(name: "posts", value: 135),
  Item(name: "followers", value: 6347),
  Item(name: "following", value: 328),
]

let valueStyle: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12).withSmallCaps]
let nameStyle: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12).withSmallCaps,
                                NSAttributedStringKey.foregroundColor: UIColor.darkGray]
let valueFormatter = NumberFormatter()
valueFormatter.numberStyle = .decimal

for item in items {
  if stackView.arrangedSubviews.count > 0 {
    let separator = UIView()
    separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
    separator.backgroundColor = .black
    stackView.addArrangedSubview(separator)
    separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4).isActive = true
  }

  let richText = NSMutableAttributedString()
  let valueString = valueFormatter.string(for: item.value)!
  richText.append(NSAttributedString(string: valueString, attributes: valueStyle))
  richText.append(NSAttributedString(string: "\n" + item.name, attributes: nameStyle))
  let label = UILabel()
  label.attributedText = richText
  label.textAlignment = .center
  label.numberOfLines = 0
  stackView.addArrangedSubview(label)

  if let firstLabel = stackView.arrangedSubviews.first as? UILabel {
    label.widthAnchor.constraint(equalTo: firstLabel.widthAnchor).isActive = true
  }
}

UIGraphicsBeginImageContextWithOptions(rootView.bounds.size, true, 1)
rootView.drawHierarchy(in: rootView.bounds, afterScreenUpdates: true)
let image = UIGraphicsGetImageFromCurrentImageContext()!
UIGraphicsEndImageContext()
let png = UIImagePNGRepresentation(image)!
let path = NSTemporaryDirectory() + "/image.png"
Swift.print(path)
try! png.write(to: URL(fileURLWithPath: path))
