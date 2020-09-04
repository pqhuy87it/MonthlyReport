https://stackoverflow.com/questions/35316655/how-to-format-localised-strings-in-swift

https://stackoverflow.com/questions/24074479/how-to-create-a-string-with-format

let x = 1.2
let y = 2.4
let text = String(format: NSLocalizedString("From %@, %@", comment: ""), "\(x)", "\(y)")
// Or alternatively:
let text = String(format: NSLocalizedString("From %@, %@", comment: ""), NSNumber(double: x), NSNumber(double: y))

"From %f, %f" = "从 %f, %f 得出";
with

let text = String(format: NSLocalizedString("From %f, %f", comment: ""), x, y)

-----

String(format: "Value: %3.2f\tResult: %3.2f", arguments: [2.7, 99.8])
or

String(format:"Value: %3.2f\tResult: %3.2f", 2.7, 99.8)

-----

let timeNow = time(nil)
let aStr = String(format: "%@%x", "timeNow in hex: ", timeNow)
print(aStr)
Example result:

timeNow in hex: 5cdc9c8d
