https://stackoverflow.com/questions/43618487/why-are-emoji-characters-like-treated-so-strangely-in-swift-strings

for char in "👩‍👩‍👧‍👦".characters {
    print(char)

    let scalars = String(char).unicodeScalars.map({ String($0.value, radix: 16) })
    print(scalars)
}

// 👩‍
// ["1f469", "200d"]
// 👩‍
// ["1f469", "200d"]
// 👧‍
// ["1f467", "200d"]
// 👦
// ["1f466"]
