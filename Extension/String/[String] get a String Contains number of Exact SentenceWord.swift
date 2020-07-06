https://stackoverflow.com/questions/58018215/how-to-get-a-string-contains-number-of-exact-sentence-word-in-swift-4

import Foundation

extension String {
    func nazmulCount(of needle: String) -> Int {
        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: needle) + "\\b"
        let rex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        return rex.matches(in: self, options: [], range: NSRange(startIndex..., in: self)).count
    }
}

"Art of swift, now art of swift5 but this is true art of swift from 2014 now what do you think about art of swift?".nazmulCount(of: "art of swift")
// 3

"Art of swift".nazmulCount(of: "art of swift")
// 1

"art of swift?".nazmulCount(of: "art of swift")
// 1

"art of swift's".nazmulCount(of: "art of swift")
// 1

"art of swiftবাং".nazmulCount(of: "art of swift")
// 0

"art of swiftly".nazmulCount(of: "art of swift")
// 0
