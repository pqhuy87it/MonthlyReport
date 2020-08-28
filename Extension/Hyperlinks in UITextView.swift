https://qiita.com/Arime/items/d9f679b13921a8bfe515

import UIKit

extension UITextView {

    /// 対象の文字列に対して、リンクを付加する
    ///
    /// - Note:
    /// textView(_:shouldInteractWith:in:interaction:) は呼び出し側で実装して下さい
    ///
    /// - Parameters:
    ///   - pattern: 対象の文字列
    ///   - urlString: URL
    ///   - color: リンク色
    func addLink(pattern: String, urlString: String = "", color: UIColor) {
        _ = _addLink(pattern: pattern, urlString: urlString, color: color)
    }

    /// 対象の文字列に対して、リンクを付加する
    ///
    /// - Note:
    /// LinkTextViewDelegateRepresents のインスタンスは呼び出し側で保持して下さい(保持しないと自動解放されるため)
    ///
    /// - Parameters:
    ///   - pattern: 対象の文字列
    ///   - urlString: URL
    ///   - color: リンク色
    ///   - action: アクション
    /// - Returns: Text view delegateを象徴するクラス
    func addLink(pattern: String, urlString: String = "", color: UIColor, action: @escaping LinkTextViewDelegateRepresents.Action) -> LinkTextViewDelegateRepresents? {
        return _addLink(pattern: pattern, urlString: urlString, color: color, action: action)
    }

    private func _addLink(pattern: String, urlString: String = "", color: UIColor, action: LinkTextViewDelegateRepresents.Action? = nil) -> LinkTextViewDelegateRepresents? {

        // Configure
        isEditable = false
        isSelectable = true
        isUserInteractionEnabled = true
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero

        // Add Color
        linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: color]

        // String
        let strings = [attributedText?.string, text].flatMap { $0 }
        guard let string = strings.first else { return nil }

        // Ranges
        let nsRanges = string.nsRanges(of: pattern, options: [.literal])
        if nsRanges.count == 0 { return nil }

        // Add Link
        let attributedString = attributedText != nil
            ? NSMutableAttributedString(attributedString: attributedText!)
            : NSMutableAttributedString(string: string)

        for nsRange in nsRanges {
            attributedString.addAttributes([.link: urlString], range: nsRange)
        }

        // Set Text
        attributedText = attributedString

        // Return
        if let action = action {
            return LinkTextViewDelegateRepresents(action: action)
        } else {
            return nil
        }
    }
}

import UIKit

final class LinkTextViewDelegateRepresents: NSObject {

    typealias Action = (_ textView: UITextView, _ url: URL, _ characterRange: NSRange, _ interaction: UITextItemInteraction) -> Bool

    var action: Action

    init(action: @escaping Action) {
        self.action = action
    }
}

extension LinkTextViewDelegateRepresents: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return action(textView, URL, characterRange, interaction)
    }
}

import Foundation

extension String {

    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    func ranges(of searchString: String, options mask: NSString.CompareOptions = [], locale: Locale? = nil) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        while let range = range(of: searchString, options: mask, range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }

    func nsRanges(of searchString: String, options mask: NSString.CompareOptions = [], locale: Locale? = nil) -> [NSRange] {
        let ranges = self.ranges(of: searchString, options: mask, locale: locale)
        return ranges.map { nsRange(from: $0) }
    }

}

let textView = UITextView()
textView.text = "Googleのリンク"
textView.addLink(pattern: "Google", urlString: "https://www.google.com", color: .blue)

class LinkSampleViewController: UIViewController, UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }

}

textView.text = "Googleのリンク"

let linkRepresents = textView.addLink(pattern: "Google", urlString: "https://www.google.com", color: .blue) { (textView, url, characterRange, interaction) -> Bool in
    return true
}
