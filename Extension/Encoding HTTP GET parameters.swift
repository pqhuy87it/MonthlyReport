// https://www.ralfebert.de/ios/examples/networking/encode-url-get-parameters/

var urlComponents = URLComponents(string: "https://www.google.de/maps/")!
urlComponents.queryItems = [
    URLQueryItem(name: "q", value: String(51.500833)+","+String(-0.141944)),
    URLQueryItem(name: "z", value: String(6))
]
urlComponents.url      // returns https://www.google.de/maps/?q=51.500833,-0.141944&z=6
