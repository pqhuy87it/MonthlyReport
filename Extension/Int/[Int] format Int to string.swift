https://stackoverflow.com/questions/25566581/leading-zeros-for-int-in-swift

import Foundation

for myInt in 1 ... 3 {
    print(String(format: "%02d", myInt))
}

01
02
03

let hours = 3
let minutes = 15
let seconds = 7
print(String(format: "%02d:%02d:%02d", hours, minutes, seconds))

03:15:07

---------------------------------------------------------------------------------

import Foundation

let string0 = String(format: "%02d", 0) // returns "00"
let string1 = String(format: "%02d", 1) // returns "01"
let string2 = String(format: "%02d", 10) // returns "10"
let string3 = String(format: "%02d", 100) // returns "100"

import Foundation

let string0 = String(format: "%02d", arguments: [0]) // returns "00"
let string1 = String(format: "%02d", arguments: [1]) // returns "01"
let string2 = String(format: "%02d", arguments: [10]) // returns "10"
let string3 = String(format: "%02d", arguments: [100]) // returns "100"

import Foundation

let formatter = NumberFormatter()
formatter.minimumIntegerDigits = 2

let optionalString0 = formatter.string(from: 0) // returns Optional("00")
let optionalString1 = formatter.string(from: 1) // returns Optional("01")
let optionalString2 = formatter.string(from: 10) // returns Optional("10")
let optionalString3 = formatter.string(from: 100) // returns Optional("100")
