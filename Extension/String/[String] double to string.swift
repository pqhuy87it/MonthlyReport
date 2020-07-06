https://stackoverflow.com/questions/25339936/swift-double-to-string

let a:Double = 1.5
let b:String = String(format:"%f", a)
print("b: \(b)") // b: 1.500000

let c:String = String(format:"%.1f", a)
print("c: \(c)") // c: 1.5

---------------------------------------------------------------------

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}

var a:Double = 1.5
println("output: \(a.toString())")  // output: 1.5
