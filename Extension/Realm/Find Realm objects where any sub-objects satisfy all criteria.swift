// https://stackoverflow.com/questions/57799728/find-realm-objects-where-any-sub-objects-satisfy-all-criteria

let results = realm.objects(Parent.self).filter(NSPredicate(format: "SUBQUERY(children, $child, $child.x == 1 && $child.y == 2).@count > 0"))

A subquery is formatted as SUBQUERY(collection, itemName, query), and returns all sub-objects matching the query. So to find parents with children matching the query, you need to check the count of the resulting sub-objects.

https://stackoverflow.com/questions/3810992/quick-explanation-of-subquery-in-nspredicate-expression/3815272#3815272
