https://stackoverflow.com/questions/24007129/how-does-one-generate-a-random-number-in-apples-swift-language

let randomInt = Int.random(in: 0..<6)
let randomDouble = Double.random(in: 2.71828...3.14159)
let randomBool = Bool.random()

----

let diceRoll = Int(arc4random_uniform(6) + 1)

---

let numbers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

import GameKit

private func randomNumberGenerator() -> Int {
    let random = GKRandomSource.sharedRandom().nextInt(upperBound: numbers.count)
    return numbers[random]
}

randomNumberGenerator()

let randomNumber = numbers.randomElement()!
print(randomNumber)
