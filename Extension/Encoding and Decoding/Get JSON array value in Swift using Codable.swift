//https://stackoverflow.com/questions/59957108/how-to-get-json-array-value-in-swift-using-codable

struct RouteOptions: Codable {
    let name: String
    let directions: [String]
}

let data = """
{ "routeOptions": [
  {
    "name": "Jubilee",
    "directions": [
      "Wembley Park Underground Station",
      "Stanmore Underground Station"
    ],
    "lineIdentifier": {
      "id": "jubilee",
      "name": "Jubilee",
      "uri": "/Line/jubilee",
      "type": "Line",
      "routeType": "Unknown",
      "status": "Unknown"
    }
  }
]}
""".data(using: .utf8)!

struct Root: Decodable {
    let routeOptions: [RouteOptions]
}

struct RouteOptions: Codable {
    let name: String
    let directions: [String]
}

do {
    let result = try JSONDecoder().decode(Root.self, from: data)
    print(result.routeOptions)
} catch {
    print(error)
}
