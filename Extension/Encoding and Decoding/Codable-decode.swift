public struct Safe<Wrapped: Decodable>: Codable {
    public let value: Wrapped?

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Wrapped.self)
        } catch {
            self.value = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


let json = """
[
    {"name": "Taro"},
    {"name": 123}
]
""".data(using: .utf8)!

struct User: Decodable {
    let name: String
}

let users = try! JSONDecoder().decode([Safe<User>].self,
                                      from: json)
users[0].value?.name //=> "Taro"
users[1].value //=> nil

let json2 = """
{"url": "https://foo.com", "url2": "invalid url string"}
""".data(using: .utf8)!

struct Model: Decodable {
    let url: Safe<URL>
    let url2: Safe<URL>
}

let model = try! JSONDecoder().decode(Model.self,
                                      from: json)
model.url.value?.absoluteString //=> "https://foo.com"
model.url2.value //=> nil