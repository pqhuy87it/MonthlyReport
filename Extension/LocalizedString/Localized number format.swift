https://stackoverflow.com/questions/24960621/struggling-with-nsnumberformatter-in-swift-for-currency

let price = 123.436 as NSNumber

let formatter = NumberFormatter()
formatter.numberStyle = .currency
// formatter.locale = NSLocale.currentLocale() // This is the default
// In Swift 4, this ^ has been renamed to simply NSLocale.current
formatter.string(from: price) // "$123.44"

formatter.locale = Locale(identifier: "es_CL")
formatter.string(from: price) // $123"

formatter.locale = Locale(identifier: "es_ES")
formatter.string(from: price) // "123,44 €"


