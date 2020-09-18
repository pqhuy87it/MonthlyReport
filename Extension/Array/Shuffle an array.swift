https://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift/24029847#24029847

let x = [1, 2, 3].shuffled()
// x == [2, 3, 1]

let fiveStrings = stride(from: 0, through: 100, by: 5).map(String.init).shuffled()
// fiveStrings == ["20", "45", "70", "30", ...]

var numbers = [1, 2, 3, 4]
numbers.shuffle()
// numbers == [3, 2, 1, 4]

---

extension Array {
    func shuffled(using source: GKRandomSource) -> [Element] {
        return (self as NSArray).shuffled(using: source) as! [Element]
    }
    func shuffled() -> [Element] {
        return (self as NSArray).shuffled() as! [Element]
    }
}
let shuffled3 = array.shuffled(using: random)
let shuffled4 = array.shuffled()

---

if you just want a unique shuffle:

let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: array)
