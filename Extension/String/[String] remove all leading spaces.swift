https://stackoverflow.com/questions/28570973/how-should-i-remove-all-the-leading-spaces-from-a-string-swift

let trimmedString = string.trimmingCharacters(in: .whitespaces)


Swift 4, 4.2 and 5

Remove space from front and end only

let str = "  Akbar Code  "
let trimmedString = str.trimmingCharacters(in: .whitespacesAndNewlines)
Remove spaces from every where in the string

let stringWithSpaces = " The Akbar khan code "
let stringWithoutSpaces = stringWithSpaces.replacingOccurrences(of: " ", with: "")
