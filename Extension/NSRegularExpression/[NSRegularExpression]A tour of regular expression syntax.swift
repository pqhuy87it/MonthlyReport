[a-z] to mean “any letter from “a” through “z”, and in regex terms this is a character class.
[0-9] to allow any number
[A-Za-z0-9] to allow any alphanumerical letter
[A-Fa-f0-9] to match hexadecimal numbers
*, which means “zero or more matches
let regex = NSRegularExpression("ca[a-z]*d") That looks for “ca”, then zero or more characters from “a” through “z”, then “d” – it matches “cad”, “card”, “camped”, and more.
+ it means “one or more”, which is ever so slightly different from the “zero or more” of *
? it means “zero or one.”
c[a-z]*d means “c then zero or more lowercase letters, then d,” so it will match both “cd” and “camped”.
c[a-z]+d means “c then one or more lowercase letters, then d,” so it won’t match “cd” but will match “camped”.
c[a-z]?d means “c then zero or one lowercase letters, then d,” so it will match “cd” but not “camped”.
[a-z]{3} means “match exactly three lowercase letters.”
[0-9]{3}-[0-9]{4} phone number formatted like this: 111-1111
[a-z]{1,3} means “match one, two, or three lowercase letters”
[a-z]{3,} means “match at least three, but potentially any number more.”
[0-9]{3}.*[0-9]{4} some people will write “555 5555” or “5555555”
[0-9]{3}[^0-9]+[0-9]{4} will match “123-4567”, “123-4567890”, and even “123-456-789012345”. 
