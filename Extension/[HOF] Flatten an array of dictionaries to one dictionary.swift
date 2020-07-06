https://stackoverflow.com/questions/35597850/swift-flatten-an-array-of-dictionaries-to-one-dictionary

let arrayOfDictionaries = [["key1": "value1"], ["key2": "value2"], ["key3": "value3", "key4": "value4"]]

//the end result will be:   
 flattenedArray = ["key1": "value1", "key2": "value2", "key3": "value3", "key4": "value4"]
 
 // Solution
 
 let flattenedDictionary = arrayOfDictionaries
    .flatMap { $0 }
    .reduce([String:String]()) { (var dict, tuple) in
        dict.updateValue(tuple.1, forKey: tuple.0)
        return dict
    }
    
 -----------------------------------------------------------------------------------------
 
 let arrayOfDictionaries = [["key1": "value1"], ["key2": "value2"], ["key3": "value3", "key4": "value4"]]
var dic = [String: String]()
for item in arrayOfDictionaries {
    for (kind, value) in item {
        print(kind)
        dic.updateValue(value, forKey: kind)
    }


}
print(dic)

print(dic["key1"]!)
