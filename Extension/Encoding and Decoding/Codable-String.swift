ublic struct StringTo<T: LosslessStringConvertible>: Codable {
    public let value: T

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        guard let value = T(stringValue) else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath,
                      debugDescription: "The string cannot cast to \(T.self).")
            )
        }

        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.description)
    }
}


let json = """
{
    "number": "100",
}
""".data(using: .utf8)!

struct Model: Codable {
    let number: StringTo<Int>
}
let model = try! JSONDecoder().decode(Model.self, from: data)
model.number.value //=> 100 (Int型)