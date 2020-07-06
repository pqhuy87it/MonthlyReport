https://stackoverflow.com/questions/24091233/swift-split-string-over-multiple-lines

extension String {
    init(sep:String, _ lines:String...){
        self = ""
        for (idx, item) in lines.enumerated() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += sep
            }
        }
    }

    init(_ lines:String...){
        self = ""
        for (idx, item) in lines.enumerated() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += "\n"
            }
        }
    }
}



print(
    String(
        "Hello",
        "World!"
    )
)
"Hello
World!"

print(
    String(sep:", ",
        "Hello",
        "World!"
    )
)
"Hello, World!"
