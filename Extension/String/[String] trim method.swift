https://stackoverflow.com/questions/26797739/does-swift-have-a-trim-method-on-string

extension String {
    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
         self = self.trimmed()
    }

    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

---------------------------------------------------------------------------------------------------------

extension String {


    func trim() -> String {

        return self.trimmingCharacters(in: .whitespacesAndNewlines)

    }

    func trim(characterSet:CharacterSet) -> String {

        return self.trimmingCharacters(in: characterSet)

    }
}

validationMessage = validationMessage.trim(characterSet: CharacterSet(charactersIn: ","))
