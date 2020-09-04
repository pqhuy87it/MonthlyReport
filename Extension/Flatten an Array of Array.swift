https://stackoverflow.com/questions/24465281/flatten-an-array-of-arrays-in-swift

reduce:

let numbers = [[1,2,3],[4],[5,6,7,8,9]]
let reduced = numbers.reduce([], +)
flatMap:

let numbers = [[1,2,3],[4],[5,6,7,8,9]]
let flattened = numbers.flatMap { $0 }
joined:

let numbers = [[1,2,3],[4],[5,6,7,8,9]]
let joined = Array(numbers.joined())

![](https://i.stack.imgur.com/mdyiC.png)
