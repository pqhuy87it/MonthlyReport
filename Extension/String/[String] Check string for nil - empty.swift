https://stackoverflow.com/questions/29381994/check-string-for-nil-empty

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}

------------------------------------------------------

extension Optional where Wrapped == String {

    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

}

extension Optional where Wrapped: Collection {

    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

}

Usage with Strings:

let optionalString: String? = nil
print(optionalString.isNilOrEmpty) // prints: true
let optionalString: String? = ""
print(optionalString.isNilOrEmpty) // prints: true
let optionalString: String? = "Hello"
print(optionalString.isNilOrEmpty) // prints: false
Usage with Arrays:

let optionalArray: Array<Int>? = nil
print(optionalArray.isNilOrEmpty) // prints: true
let optionalArray: Array<Int>? = []
print(optionalArray.isNilOrEmpty) // prints: true
let optionalArray: Array<Int>? = [10, 22, 3]
print(optionalArray.isNilOrEmpty) // prints: false
