// https://stackoverflow.com/questions/3810992/quick-explanation-of-subquery-in-nspredicate-expression/3815272#3815272

And for people who don't quite get what the documentation is saying, a SUBQUERY is essentially this:

SUBQUERY(collection, variableName, predicateFormat)
And could (simplistically) be implemented like this:

id resultingCollection = ...; //a new collection, either a mutable set or array
NSMutableDictionary * substitutions = [NSMutableDictionary dictionary];
NSPredicate * p = [NSPredicate predicateWithFormat:predicateFormat];
for (id variable in collection) {
  [substitutions setObject:variable forKey:variableName];
  NSPredicate * filter = [p predicateWithSubstitutionVariables:substitutions];
  if ([filter evaluateWithObject:collection] == YES) {
    [resultingCollection addObject:variable];
  }
}
return resultingCollection;
So in a nutshell, a SUBQUERY is basically taking a collection of objects and filtering out various objects based on the predicate expression of the SUBQUERY, and returning the resulting collection. (And the predicate itself can contain other SUBQUERYs)

Example:

NSArray * arrayOfArrays = [NSArray arrayWithObjects:
                           [NSArray arrayWithObjects:....],
                           [NSArray arrayWithObjects:....],
                           [NSArray arrayWithObjects:....],
                           [NSArray arrayWithObjects:....],
                           [NSArray arrayWithObjects:....],
                           [NSArray arrayWithObjects:....],
                           nil];
NSPredicate * filter = [NSPredicate predicateWithFormat:@"SUBQUERY(SELF, $a, $a.@count > 42)"];
NSArray * filtered = [arrayOfArrays filteredArrayUsingPredicate:filter];
//"filtered" is an array of arrays
//the only arrays in "filtered" will have at least 42 elements each
