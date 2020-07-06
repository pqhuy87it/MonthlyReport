https://stackoverflow.com/questions/46690337/display-japanese-text-with-furigana-in-uilabel/47377024#47377024
https://qiita.com/negi0205/items/6c73128ff2cf680df47c

import UIKit

extension String {
    func find(pattern: String) -> NSTextCheckingResult? {
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            return re.firstMatch(
                in: self,
                options: [],
                range: NSMakeRange(0, self.utf16.count))
        } catch {
            return nil
        }
    }

    func replace(pattern: String, template: String) -> String {
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            return re.stringByReplacingMatches(
                in: self,
                options: [],
                range: NSMakeRange(0, self.utf16.count),
                withTemplate: template)
        } catch {
            return self
        }
    }
}



class Utility: NSObject {
    class var sharedInstance: Utility {
        struct Singleton {
            static let instance = Utility()
        }
        return Singleton.instance
    }

    func furigana(String:String) -> NSMutableAttributedString {
        let attributed =
            String
                .replace(pattern: "(｜.+?《.+?》)", template: ",$1,")
                .components(separatedBy: ",")
                .map { x -> NSAttributedString in
                    if let pair = x.find(pattern: "｜(.+?)《(.+?)》") {
                        let string = (x as NSString).substring(with: pair.range(at: 1))
                        let ruby = (x as NSString).substring(with: pair.range(at: 2))

                        var text: [Unmanaged<CFString>?] = [Unmanaged<CFString>.passRetained(ruby as CFString) as Unmanaged<CFString>, .none, .none, .none]
                        let annotation = CTRubyAnnotationCreate(CTRubyAlignment.auto, CTRubyOverhang.auto, 0.5, &text[0])

                        return NSAttributedString(
                            string: string,
                            attributes: [kCTRubyAnnotationAttributeName as NSAttributedStringKey: annotation])
                    } else {
                        return NSAttributedString(string: x, attributes: nil)
                    }
                }
                .reduce(NSMutableAttributedString()) { $0.append($1); return $0 }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.lineSpacing = 12
        attributed.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, (attributed.length)))
        attributed.addAttributes([NSAttributedStringKey.font: UIFont(name: "HiraMinProN-W3", size: 14.0)!, NSAttributedStringKey.verticalGlyphForm: false,],range: NSMakeRange(0, (attributed.length)))

        return attributed
    }

}

import UIKit

protocol SimpleVerticalGlyphViewProtocol {
}

extension SimpleVerticalGlyphViewProtocol {

    func drawContext(_ attributed:NSMutableAttributedString, textDrawRect:CGRect, isVertical:Bool) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        var path:CGPath
        if isVertical {
            context.rotate(by: .pi / 2)
            context.scaleBy(x: 1.0, y: -1.0)
            path = CGPath(rect: CGRect(x: textDrawRect.origin.y, y: textDrawRect.origin.x, width: textDrawRect.height, height: textDrawRect.width), transform: nil)
        }
        else {
            context.textMatrix = CGAffineTransform.identity
            context.translateBy(x: 0, y: textDrawRect.height)
            context.scaleBy(x: 1.0, y: -1.0)
            path = CGPath(rect: textDrawRect, transform: nil)
        }

        let framesetter = CTFramesetterCreateWithAttributedString(attributed)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributed.length), path, nil)

        CTFrameDraw(frame, context)
    }
}

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var furiganaLabel: CustomLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        furiganaLabel.attributedText = Utility.sharedInstance.furigana(String: "｜優勝《ゆうしょう》の｜懸《か》かった｜試合《しあい》。")
    }
}

class CustomLabel: UILabel, SimpleVerticalGlyphViewProtocol {
    //override func draw(_ rect: CGRect) { // if not has drawText, use draw UIView etc
    override func drawText(in rect: CGRect) {
        let attributed = NSMutableAttributedString(attributedString: self.attributedText!)
        let isVertical = false // if Vertical Glyph, true.
        attributed.addAttributes([NSAttributedStringKey.verticalGlyphForm: isVertical], range: NSMakeRange(0, attributed.length))
        drawContext(attributed, textDrawRect: rect, isVertical: isVertical)
    }
}
