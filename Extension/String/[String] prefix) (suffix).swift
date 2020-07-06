https://stackoverflow.com/questions/32967445/how-to-check-what-a-string-starts-with-prefix-or-ends-with-suffix-in-swift

let str = "Hello, playground"

if str.hasPrefix("Hello") { // true
    print("Prefix exists")
}

if str.hasSuffix("ground") { // true
    print("Suffix exists")
}
