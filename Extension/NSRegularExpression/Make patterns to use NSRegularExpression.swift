https://stackoverflow.com/questions/54124406/make-patterns-to-use-nsregularexpression

let string = "~This two~ are *bold text* and different <textcolor> and ~strikethrough~ and _italic (word*)_ ~abc~"
let pattern = "((^|)~(.*?)(\\S+)~($|\\s))"

Output is 

Pattern: ((^|)~(.*?)(\S+)~($|\s))
~This two~ 
~strikethrough~ 
~abc~

let string = "~This two~ are *bold text* and different <textcolor> and ~strikethrough~ and _italic (word*)_ ~abc~"
let pattern = "((^|)~(.?)(\\S+)~($|\\s))" //here '*' removed

Output is

Pattern: ((^|)~(.?)(\S+)~($|\s))
~strikethrough~ 
~abc~

----

//Some randome bunch of words
let string = "1. *うちに* comes from the ~kanji~ *内* which mean “inside” or “within” and has _two distinct_ meanings in Japanese. 2. Firstly, it shows that something happens within ~a~ period of time. “While” something is happening, you do an action.~Very minimal as~ far as features tha *t* are supported in the Web version. It works in a pinch, if you’re in a hurry and ne. Nice~"

//to find words which are suppose to be stricked using '~' character
let pattern = "~[^\\s](.*?[^\\s])??~"

let regex = try! NSRegularExpression(pattern: pattern, options: [])
let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
matches.forEach { (aMatch) in
    let matchedRange = aMatch.range(at: 0)
    let matchingText = (string as NSString).substring(with: matchedRange)
    print(matchingText)
}

----

let string = "~This two~ are *bold text* and different <textcolor> and ~strikethrough~ and _italic (word*)_ ~abc~"

let embedded = ".*?"

let strikeThroughGroupName = "strikethroughGroupName"
let boldGroupName = "boldGroupName"
let colorGroupName = "colorGroupName"
let italicGroupName = "italicGroupName"
let groupNames = [strikeThroughGroupName, boldGroupName, italicGroupName, colorGroupName]

let pattern = "(~(?<\(strikeThroughGroupName)>\(embedded))~)|(<(?<\(colorGroupName)>\(embedded))>)|(_(?<\(italicGroupName)>\(embedded))_)|(\\*(?<\(boldGroupName)>\(embedded))\\*)"

print("Pattern: \(pattern)")

do {
    let regex = try NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
    matches.forEach { (aMatch) in

        if let groupFound = groupNames.first(where: { aMatch.range(withName: $0).location != NSNotFound }),
            let range = Range(aMatch.range(withName: groupFound), in: string) {
            let textFound = string[range]
            print("Found: \(textFound) with effect: \(groupFound) at NSRange: \(aMatch.range(withName: groupFound))")
        }
        let fullNSRange = aMatch.range
        if let fullRange = Range(fullNSRange, in: string) {
            let textFound = string[fullRange]
            print("Full Text Found: \(textFound)")
        }
    }
} catch {
    print("Regex error: \(error)")
}

Output:

$>Pattern: (~(?<strikethroughGroupName>.*?)~)|(<(?<colorGroupName>.*?)>)|(_(?<italicGroupName>.*?)_)|(\*(?<boldGroupName>.*?)\*)
$>Found: This two with effect: strikethroughGroupName at NSRange: {1, 8}
$>Full Text Found: ~This two~
$>Found: bold text with effect: boldGroupName at NSRange: {16, 9}
$>Full Text Found: *bold text*
$>Found: strikethrough with effect: strikethroughGroupName at NSRange: {59, 13}
$>Full Text Found: ~strikethrough~
$>Found: italic (word*) with effect: italicGroupName at NSRange: {79, 14}
$>Full Text Found: _italic (word*)_
$>Found: abc with effect: strikethroughGroupName at NSRange: {96, 3}
$>Full Text Found: ~abc~

---

let string = "~This two~ are *bold text* and different <textcolor> and ~strikethrough~ and _italic (word*)_ ~abc~"
let textPattern = "[:alpha:][:punct:][:space:]"
let range = NSRange(location: 0, length: string.utf16.count)
let patterns:[String] = ["(?:~([\(textPattern)]*)~)", "(?:\\*([\(textPattern)]*)\\*)", "(?:<([\(textPattern)]*)>)", "(?:_([\(textPattern)]*)_)"]

for pattern in patterns {
    let regex = try! NSRegularExpression(pattern: pattern)
    regex.enumerateMatches(in: string, range: range, using: { (result, flag, pointer) in 
        if let result = result { 
            for i in 1..<result.numberOfRanges {
                let srange = Range(result.range(at: i))! 
                let start = String.Index(encodedOffset: srange.lowerBound)
                let end = String.Index(encodedOffset: srange.upperBound)
                let substr = String(string[start..<end])
                print("\(result.range(at: i)) => \(substr)")
            }
        }
    })
}

Output

{1, 8} => This two
{58, 13} => strikethrough
{95, 3} => abc
{16, 9} => bold text
{42, 9} => textcolor
{78, 14} => italic (word*)
