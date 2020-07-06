https://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift

![](https://i.stack.imgur.com/IKS4o.png)

var str = "Hello, playground"

let index = str.index(str.startIndex, offsetBy: 5)
let mySubstring = str[..<index] // Hello

let index = str.index(str.startIndex, offsetBy: 5)
let mySubstring = str.prefix(upTo: index) // Hello

let mySubstring = str.prefix(5) // Hello

let index = str.index(str.endIndex, offsetBy: -10)
let mySubstring = str[index...] // playground

let index = str.index(str.endIndex, offsetBy: -10)
let mySubstring = str.suffix(from: index) // playground

let mySubstring = str.suffix(10) // playground

let start = str.index(str.startIndex, offsetBy: 7)
let end = str.index(str.endIndex, offsetBy: -6)
let range = start..<end

let mySubstring = str[range]  // play

-------------------------------------------------------------

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

let str = "Hello, playground"
print(str.substring(from: 7))         // playground
print(str.substring(to: 5))           // Hello
print(str.substring(with: 7..<11))    // play
