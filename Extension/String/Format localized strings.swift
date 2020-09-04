https://stackoverflow.com/questions/35316655/how-to-format-localised-strings-in-swift

let x = 1.2
let y = 2.4
let text = String(format: NSLocalizedString("From %@, %@", comment: ""), "\(x)", "\(y)")
// Or alternatively:
let text = String(format: NSLocalizedString("From %@, %@", comment: ""), NSNumber(double: x), NSNumber(double: y))

"From %f, %f" = "从 %f, %f 得出";
with

let text = String(format: NSLocalizedString("From %f, %f", comment: ""), x, y)
