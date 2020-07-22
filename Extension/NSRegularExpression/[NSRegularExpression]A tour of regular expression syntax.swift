. matches any character. p.p matches pop, pup, pmp, p@p, and so on.
\w matches any “word-like” character which includes the set of numbers, letters, and underscore, but does not match punctuation or other symbols. hello\w will match “hello_9” and “helloo” but not “hello!”
\d matches a numeric digit, which in most cases means [0-9]. \d\d?:\d\d will match strings in time format, such as “9:30” and “12:45”.
\b matches word boundary characters such as spaces and punctuation. to\b will match the “to” in “to the moon” and “to!”, but it will not match “tomorrow”. \b is handy for “whole word” type matching.
\s matches whitespace characters such as spaces, tabs, and newlines. hello\s will match “hello ” in “Well, hello there!”.
^ matches at the beginning of a line. Note that this particular ^ is different from ^ inside of the square brackets! For example, ^Hello will match against the string “Hello there”, but not “He said Hello”.
$ matches at the end of a line. For example, the end$ will match against “It was the end” but not “the end was near”
* matches the previous element 0 or more times. 12*3 will match 13, 123, 1223, 122223, and 1222222223
+ matches the previous element 1 or more times. 12+3 will match 123, 1223, 122223, 1222222223, but not 13.
Curly braces {} contain the minimum and maximum number of matches. For example, 10{1,2}1 will match both “101” and “1001” but not “10001” as the minimum number of matches is 1 and the maximum number of matches is 2. 
He[Ll]{2,}o will match “HeLLo” and “HellLLLllo” and any such silly variation of “hello” with lots of L’s, since the minimum number of matches is 2 but the maximum number of matches is not set — and therefore unlimited!

---

If you want to search for one of these characters, you need to escape it with a backslash. 
For example, to search for all periods in a block of text, the pattern is not . but rather \.

As an extra complication, since regular expressions are strings themselves, the backslash character needs to be escaped when working with NSString and NSRegularExpression. 
That means the standard regular expression \. will be written as \\. in your code.

To clarify the above concept in point form:
The literal @"\\." defines a string that looks like this: \.
The regular expression \. will then match a single period character

---

3 (pm|am) would match the text “3 pm” as well as the text “3 am”. The pipe character here (|) acts like an OR operator.

---

t[aeiou] will match “ta”, “te”, “ti”, “to”, or “tu”. 
[aeiou] looks like five characters, but it actually means “a” or “e” or “i” or “o” or “u”.
[a-f] will match “a”, “b”, “c”, “d”, “e”, or “f”.

---

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

----

https://www.regexpal.com
