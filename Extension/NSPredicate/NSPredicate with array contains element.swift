https://stackoverflow.com/questions/57658686/how-to-create-nspredicate-with-array-contains-element

// The you can fetch all addresses which have any (i.e.: at least one) favorite equal to the string "a" with the predicate

NSPredicate(format: "ANY favourites.name == %@", "a")
// or better with a compiler-checked key path literal:

NSPredicate(format: "ANY %K == %@", #keyPath(Address.favourites.name), "a")
// For a case-insensitive comparison you can use

NSPredicate(format: "ANY %K ==[c] %@", #keyPath(Address.favourites.name), "a")
