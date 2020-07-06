https://stackoverflow.com/questions/24034043/how-do-i-check-if-a-string-contains-another-string-in-swift

extension String {
    func contains(other: String) -> Bool{
        var start = startIndex

        do{
            var subString = self[Range(start: start++, end: endIndex)]
            if subString.hasPrefix(other){
                return true
            }

        }while start != endIndex

        return false
    }

    func containsIgnoreCase(other: String) -> Bool{
        var start = startIndex

        do{
            var subString = self[Range(start: start++, end: endIndex)].lowercaseString
            if subString.hasPrefix(other.lowercaseString){
                return true
            }

        }while start != endIndex

        return false
    }
}

-----------------------------------------------------------------------------------------

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

var value = "Hello world"

print(value.contains("Hello")) // true
print(value.contains("bo"))    // false

print(value.containsIgnoringCase(find: "hello"))    // true
print(value.containsIgnoringCase(find: "Hello"))    // true
print(value.containsIgnoringCase(find: "bo"))       // false

-------------------------------------------------------------------------------

var string = "hello Swift"

if string.rangeOfString("Swift") != nil{ 
    println("exists")
}

// alternative: not case sensitive
if string.lowercaseString.rangeOfString("swift") != nil {
    println("exists")
}
