https://stackoverflow.com/questions/51492454/swift-string-replace-and-get-new-range

class StringService {

  /** create an object to access every method because this class provides you services */

  static let shared = StringService()


  /** Service classes should not be available for creating instances */

  private init () {}


  func replace(mySting: String ,by: String, with: String) -> (String,Range<String.Index>?) {

     var newString = ""

     if let range = myString.range(of:by) {

        newString.replaceSubrange(range,with:with)

        return (newString,range)

      }esle{

        return ("",nil)

      }
  }
  
  let replacedString = StringService.shared.replace(mySting: "myString is",
                                                  by: "is",
                                                  with: "was").0

if let replacedStringRange = StringService.shared.replace(mySting: "myString is",
                                                  by: "is",
                                                  with: "was").1 {

}

--------------------------------------------------------------------------------

extension String {

    func replacingOccurrences<T: StringProtocol>(of toReplace: T,
                                                 with newString: T,
                                                 options: String.CompareOptions = [],
                                                 range searchRange: Range<T.Index>? = nil,
                                                 completion: ((Range<T.Index>?, Range<T.Index>?) -> Void)) -> String {

        let oldRange = range(of: toReplace)

        let replacedString = replacingOccurrences(of: toReplace,
                                                  with: newString,
                                                  options: options,
                                                  range: searchRange)

        let newRange = replacedString.range(of: newString)

        completion(oldRange, newRange)

        return replacedString
    }

    mutating func replaceOccurrences<T: StringProtocol>(of toReplace: T,
                                                        with newString: T,
                                                        options: String.CompareOptions = [],
                                                        range searchRange: Range<T.Index>? = nil,
                                                        completion: ((Range<T.Index>?, Range<T.Index>?) -> Void)) {

        self = replacingOccurrences(of: toReplace,
                                    with: newString,
                                    options: options,
                                    range: searchRange,
                                    completion: completion)
    }
}

let username = "apple"
var msgString = "{{user}} has an apple"

msgString.replaceOccurrences(of: "{{user}}", with: username) { (oldRange, newRange) in
    print(oldRange)
    print(newRange)
}
