https://stackoverflow.com/questions/33815495/creating-rangestring-index-from-constant-ints

let startIndex = text.startIndex
let endIndex = text.endIndex

var range1 = startIndex.advancedBy(1) ..< text.endIndex.advancedBy(-4)
var range2 = startIndex.advancedBy(0) ..< startIndex.advancedBy(5)
var range3 = startIndex ..< endIndex

------------------------------------------------------------------------------------------------

https://stackoverflow.com/questions/30093688/how-to-create-range-in-swift
