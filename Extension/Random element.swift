https://www.simpleswiftguide.com/how-to-pick-a-random-element-from-an-array-in-swift/

let array = ["Swift", "SwiftUI", "UIKit", "Foundation”]

guard array.count > 0 else {
    return
}

let randomElement = array.randomElement()!
print(randomElement)
