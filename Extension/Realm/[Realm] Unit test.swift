https://blog.moritzhaarmann.de/daily/2016/02/15/realm-testing.html

class RealmProvider {
    class func realm() -> Realm {
        if let _ = NSClassFromString("XCTest") {
            return try! Realm(configuration: Realm.Configuration(path: nil, inMemoryIdentifier: "test", encryptionKey: nil, readOnly: false, schemaVersion: 0, migrationBlock: nil, objectTypes: nil))
        } else {
            return try! Realm();
   
        }
    }
}

override func setUp() {
    super.setUp()
    let realm = RealmProvider.realm()
    try! realm.write { () -> Void in
        realm.deleteAll()
    }
}
