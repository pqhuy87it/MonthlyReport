https://stackoverflow.com/questions/26277626/nslocalizedstring-with-swift-variable

extension String {

    /// Fetches a localized String
    ///
    /// - Returns: return value(String) for key
    public func localized() -> String {
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return (bundle?.localizedString(forKey: self, value: nil, table: nil))!
    }


    /// Fetches a localised String Arguments
    ///
    /// - Parameter arguments: parameters to be added in a string
    /// - Returns: localized string
    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized(), locale: nil, arguments: arguments)
    }

}

// variable in a class
 let tcAndPPMessage = "By_signing_up_or_logging_in,_you_agree_to_our"
                                     .localized(with: [tAndc, pp, signin])

// Localization File String
"By_signing_up_or_logging_in,_you_agree_to_our" = "By signing up or logging in, you agree to our \"%@\" and \"%@\" \nAlready have an Account? \"%@\"";
