https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift

func randomStringWithLength (len : Int) -> NSString {

    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    var randomString : NSMutableString = NSMutableString(capacity: len)

    for (var i=0; i < len; i++){
        var length = UInt32 (letters.length)
        var rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }

    return randomString
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

--------------------------------------------------------------------------------------------

extension String {

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

---------------------------------------------------------------------------------------------

func generateRandom(size: UInt) -> String {
        let prefixSize = Int(min(size, 43))
        let uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return String(Data(uuidString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .prefix(prefixSize))
    }
    
    for _ in 0...10 {
    print(generateRandom(size: 32))
}

Nzk3NjgzMTdBQ0FBNDFCNzk2MDRENzZF
MUI5RURDQzE1RTdCNDA3RDg2MTI4QkQx
M0I3MjJBRjVFRTYyNDFCNkI5OUM1RUVC
RDA1RDZGQ0IzQjI1NDdGREI3NDgxM0Mx
NjcyNUQyOThCNzhCNEVFQTk1RTQ3NTIy
MDkwRTQ0RjFENUFGNEFDOTgyQTUxODI0
RDU2OTNBOUJGMDE4NDhEODlCNEQ1NjZG
RjM2MTUxRjM4RkY3NDU2OUFDOTI0Nzkz
QzUwOTE1N0U1RDVENDE4OEE5NTM2Rjcy
Nzk4QkMxNUJEMjYwNDJDQjhBQkY5QkY5
ODhFNjU0MDVEMUI2NEI5QUIyNjNCNkVF

---------------------------------------------------------------------

func randomNameString(length: Int = 7)->String{

    enum s {
        static let c = Array("abcdefghjklmnpqrstuvwxyz12345789".characters)
        static let k = UInt32(c.count)
    }

    var result = [Character](repeating: "a", count: length)

    for i in 0..<length {
        let r = Int(arc4random_uniform(s.k))
        result[i] = s.c[r]
    }

    return String(result)
}
