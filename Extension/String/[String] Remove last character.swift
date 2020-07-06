https://stackoverflow.com/questions/24122288/remove-last-character-from-string-swift-language

var str = "Hello, World"                           // "Hello, World"
str.dropLast()                                     // "Hello, Worl" (non-modifying)
str                                                // "Hello, World"
String(str.dropLast())                             // "Hello, Worl"

str.remove(at: str.index(before: str.endIndex))    // "d"
str  

------------------------------------------------------------------------------------------

extension String {

    func removeCharsFromEnd(count: Int) -> String {
		let stringLength = self.count

		let substringIndex = (stringLength < count) ? 0 : stringLength - count

		return self.subString(fromIndex: 0, toIndex: substringIndex)
	}
}
