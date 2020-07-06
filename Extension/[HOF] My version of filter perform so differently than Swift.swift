https://stackoverflow.com/questions/34540874/why-does-my-version-of-filter-perform-so-differently-than-swifts

import Darwin

extension Array {
    func myFilter(@noescape predicate: Element -> Bool) -> [Element] {
        var filteredArray = [Element]()
        for x in self where predicate(x) {
            filteredArray.append(x)
        }

        return filteredArray
    }
}

let arr = [Int](1...1000000)

var start = mach_absolute_time()
let _ = arr.filter{ $0 % 2 == 0}
var end = mach_absolute_time()
print("filter:         \(end-start)")

start = mach_absolute_time()
let _ = arr.myFilter{ $0 % 2 == 0}
end = mach_absolute_time()
print("myFilter:       \(end-start)")

------------------------------------------------------------------------------------

extension Array {
    func originalFilter(
        @noescape includeElement: (Generator.Element) throws -> Bool
        ) rethrows -> [Generator.Element] {

            var result = ContiguousArray<Generator.Element>()

            var generator = generate()

            while let element = generator.next() {
                if try includeElement(element) {
                    result.append(element)
                }
            }

            return Array(result)
    }

}

start = mach_absolute_time()
let _ = arr.originalFilter{ $0 % 2 == 0}
end = mach_absolute_time()
print("originalFilter: \(end-start)")
