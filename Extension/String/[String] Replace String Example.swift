https://www.dotnetperls.com/replace-swift

Swift program that replaces string with replaceSubrange

var value = "green red blue"
print(value)

// Replace range at positions 6 through 9.
// ... Specify a replacement string.
let start = value.index(value.startIndex, offsetBy: 6);
let end = value.index(value.startIndex, offsetBy: 6 + 3);
value.replaceSubrange(start..<end, with: "yellow")
print(value)

Output

green red blue
green yellow blue

var value = "123abc123"
var result = String()

// Replace individual characters in the string.
// ... Append them to a new string.
for char in value.characters {
    if char == "1" {
        let temp: Character = "9"
        result.append(temp)
    }
    else {
        result.append(char)
    }
}

print(result)

Output

923abc923

let text = "cats and dogs"

// Replace cats with birds.
// ... Use Foundation method.
let result = text.replacingOccurrences(of: "cats", with: "birds")

// Print result.
print(result)

Output

birds and dogs

let letters = "zzzy"
// Replace first three characters with a string.
let start = letters.startIndex;
let end = letters.index(letters.startIndex, offsetBy: 3);
let result = letters.replacingCharacters(in: start..<end, with: "wh")
// The result.
print(result)

Output

why
