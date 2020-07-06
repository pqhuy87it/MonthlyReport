https://stackoverflow.com/questions/43379451/how-to-limit-the-number-of-characters-in-a-string-or-attributed-string-in-swift

lab.numberOfLines = 2
    let s = "Little poltergeists make up the principle form of material " +
        "manifestation. Now is the time for all good men to come to the " +
        "aid of the country."
    let atts = [NSFontAttributeName: UIFont(name: "Georgia", size: 18)!]
    let arr = s.components(separatedBy: " ")
    for max in (1..<arr.count).reversed() {
        let s = arr[0..<max].joined(separator: " ")
        let attrib = NSMutableAttributedString(string: s, attributes: atts)
        let height = attrib.boundingRect(with: CGSize(width:lab.bounds.width, 
                                                      height:10000),
                                         options: [.usesLineFragmentOrigin],
                                         context: nil).height
        if height < lab.bounds.height {
            let s = arr[0..<max-1].joined(separator: " ") + "…"
            let attrib = NSMutableAttributedString(string: s, attributes: atts)
            lab.attributedText = attrib
            break
        }
    }
