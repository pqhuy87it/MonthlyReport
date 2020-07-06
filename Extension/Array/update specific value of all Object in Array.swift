https://stackoverflow.com/questions/59925964/how-to-update-specific-value-of-all-object-in-array-swift

struct ViewHolder {
    let name: String
    let age: Int
    var isMarried: Bool
}

var viewHolders: [ViewHolder] = [.init(name: "Steve Jobs", age: 56, isMarried: true),
                                 .init(name: "Tim Cook", age: 59, isMarried: true)]


viewHolders.indices.forEach {
    viewHolders[$0].isMarried = false
}

viewHolders  // [{name "Steve Jobs", age 56, isMarried false}, {name "Tim Cook", age 59, isMarried false}]
