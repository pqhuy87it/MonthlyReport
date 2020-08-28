https://stackoverflow.com/questions/24051314/precision-string-format-specifier-in-swift

import Foundation

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

let someInt = 4, someIntFormat = "03"
println("The integer number \(someInt) formatted with \"\(someIntFormat)\" looks like \(someInt.format(someIntFormat))")
// The integer number 4 formatted with "03" looks like 004

let someDouble = 3.14159265359, someDoubleFormat = ".3"
println("The floating point number \(someDouble) formatted with \"\(someDoubleFormat)\" looks like \(someDouble.format(someDoubleFormat))")
// The floating point number 3.14159265359 formatted with ".3" looks like 3.142

---

import Foundation // required for String(format: _, _)

print(String(format: "hex string: %X", 123456))
print(String(format: "a float number: %.5f", 1.0321))
