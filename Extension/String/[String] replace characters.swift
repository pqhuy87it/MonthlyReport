https://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string

let aString = "This is my string"
let newString = aString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

let aString = "This is my string"
let newString = aString.replacingOccurrences(of: " ", with: "+")

let toArray = aString.components(separatedBy: " ")
let backToString = toArray.joined(separator: "+")

let aString = "Some search text"

let replaced = String(aString.map {
    $0 == " " ? "+" : $0
})
