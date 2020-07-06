https://stackoverflow.com/questions/24701075/swift-convert-enum-value-to-string

enum Foo : CustomStringConvertible {
  case Bing
  case Bang
  case Boom

  var description : String { 
    switch self {
    // Use Internationalization, as appropriate.
    case .Bing: return "Bing"
    case .Bang: return "Bang"
    case .Boom: return "Boom"
    }
  }
}
