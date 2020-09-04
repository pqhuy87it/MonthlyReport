https://qiita.com/masakihori/items/9067ce98557ed3a9b132

import Foundation

protocol Localizable {

    var key: String { get }
    var table: String? { get }
    var bundle: Bundle { get }
    var comment: String { get }

    var string: String { get }
}

extension Localizable {

    var string: String {

        return NSLocalizedString(key, tableName: table, bundle: bundle, comment: comment)
    }
}

struct LocalizedString: Localizable {

    let key: String
    let table: String? = nil
    let bundle: Bundle = .main
    let comment: String


    init(_ string: String, comment: String) {
        self.key = string
        self.comment = comment
    }
}

struct LocalizedStringFromTable: Localizable {

    let key: String
    let table: String?
    let bundle: Bundle = .main
    let comment: String


    init(_ string: String, tableName: String, comment: String) {
        self.key = string
        self.table = tableName
        self.comment = comment
    }
}

// これはなくていい。というかない方がいい？
struct LocalizedStringFromTableInBundle: Localizable {

    let key: String
    let table: String?
    let bundle: Bundle
    let comment: String


    init(_ string: String, tableName: String, bundle: Bundle, comment: String) {
        self.key = string
        self.table = tableName
        self.bundle = bundle
        self.comment = comment
    }
}

// NSLocalizedStringWithDefaultValue を使う人はここに書くんだ！　僕は使わない！！！

struct LocalizedStrings {

    static let Hoge = LocalizedString("Hoge", comment: "Hoge Comment")
    static let Fuga = LocalizedStringFromTable("Fuga", tableName: "TableA", comment: "Fuga Comment")
    static let Piyo = LocalizedStringFromTableInBundle("Piyo", tableName: "TableB", bundle: Bundle(for: NSObject.self), comment: "Piyo Comment")
}

let localized = LocalizedStrings.Hoge.string
