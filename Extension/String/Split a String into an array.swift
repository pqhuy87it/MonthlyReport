https://stackoverflow.com/questions/25678373/split-a-string-into-an-array-in-swift

let fullName = "First Last"
let components = fullName.split{ $0.isLetter == false }
