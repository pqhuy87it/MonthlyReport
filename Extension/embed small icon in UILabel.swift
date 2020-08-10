https://stackoverflow.com/questions/19318421/how-to-embed-small-icon-in-uilabel

/ Create Attachment
let imageAttachment = NSTextAttachment()
imageAttachment.image = UIImage(named:"iPhoneIcon")
// Set bound to reposition
let imageOffsetY: CGFloat = -5.0
imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
// Create string with attachment
let attachmentString = NSAttributedString(attachment: imageAttachment)
// Initialize mutable string
let completeText = NSMutableAttributedString(string: "")
// Add image to mutable string
completeText.append(attachmentString)
// Add your text to mutable string
let textAfterIcon = NSAttributedString(string: "Using attachment.bounds!")
completeText.append(textAfterIcon)
self.mobileLabel.textAlignment = .center
self.mobileLabel.attributedText = completeText

https://github.com/anatoliyv/SMIconLabel

var labelLeft = SMIconLabel(frame: CGRectMake(10, 10, view.frame.size.width - 20, 20))
labelLeft.text = "Icon on the left, text on the left"

// Here is the magic
labelLeft.icon = UIImage(named: "Bell") // Set icon image
labelLeft.iconPadding = 5               // Set padding between icon and label
labelLeft.numberOfLines = 0             // Required
labelLeft.iconPosition = SMIconLabelPosition.Left // Icon position
view.addSubview(labelLeft)
