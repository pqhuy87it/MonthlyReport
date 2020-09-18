var fourDigitNumber: String {
 var result = ""
 repeat {
     // Create a string with a random number 0...9999
     result = String(format:"%04d", arc4random_uniform(10000) )
 } while Set<Character>(result.characters).count < 4
 return result
}

// USAGE       
let password = fourDigitNumber
print("Generated Password : \(password)")
