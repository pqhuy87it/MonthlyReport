https://stackoverflow.com/questions/24029163/finding-index-of-character-in-swift-string

let text = "abc"
let index2 = text.index(text.startIndex, offsetBy: 2) //will call succ 2 times
let lastChar: Character = text[index2] //now we can index!

let characterIndex2 = text.index(text.startIndex, offsetBy: 2)
let lastChar2 = text[characterIndex2] //will do the same as above

let range: Range<String.Index> = text.range(of: "b")!
let index: Int = text.distance(from: text.startIndex, to: range.lowerBound)
