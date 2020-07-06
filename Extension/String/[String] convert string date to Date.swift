https://stackoverflow.com/questions/24777496/how-can-i-convert-string-date-to-nsdate

import Foundation

extension DateFormatter {

    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {

    func toDate (dateFormatter: DateFormatter) -> Date? {
        return dateFormatter.date(from: self)
    }

    func toDateString (dateFormatter: DateFormatter, outputFormat: String) -> String? {
        guard let date = toDate(dateFormatter: dateFormatter) else { return nil }
        return DateFormatter(format: outputFormat).string(from: date)
    }
}

extension Date {

    func toString (dateFormatter: DateFormatter) -> String? {
        return dateFormatter.string(from: self)
    }
}

var dateString = "14.01.2017T14:54:00"
let dateFormatter = DateFormatter(format: "dd.MM.yyyy'T'HH:mm:ss")
let date = Date()

print("original String with date:               \(dateString)")
print("date String() to Date():                 \(dateString.toDate(dateFormatter: dateFormatter)!)")
print("date String() to formated date String(): \(dateString.toDateString(dateFormatter: dateFormatter, outputFormat: "dd MMMM")!)")
let dateFormatter2 = DateFormatter(format: "dd MMM HH:mm")
print("format Date():                           \(date.toString(dateFormatter: dateFormatter2)!)")
