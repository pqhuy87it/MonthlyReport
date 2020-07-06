https://stackoverflow.com/questions/33796143/how-can-i-store-a-dictionary-with-realmswift

extension String{
func dictionaryValue() -> [String: AnyObject]
{
    if let data = self.data(using: String.Encoding.utf8) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]
            return json!

        } catch {
            print("Error converting to JSON")
        }
    }
    return NSDictionary() as! [String : AnyObject]
} }

extension NSDictionary{
    func JsonString() -> String
    {
        do{
        let jsonData: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return String.init(data: jsonData, encoding: .utf8)!
        }
        catch
        {
            return "error converting"
        }
    }
}
