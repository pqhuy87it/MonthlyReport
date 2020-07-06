https://stackoverflow.com/questions/58237243/swift-nspredicate-subquery-with-not-in

let tagName = "sad"
let predicate = NSPredicate(format: "vrTags CONTAINS[cd] %@", "\"\(tagName)\"")
print(predicate) // vrTags CONTAINS[cd] "\"sad\""

If you need to combine multiple conditions with “AND” then do it like

let p1 = NSPredicate(...)
let p2 = NSPredicate(...)
// ...
let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, ...])
