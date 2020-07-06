https://stackoverflow.com/questions/38369370/error-not-caught-when-saving-to-realm-with-duplicate-primarykey

static func save(article: Article) -> Bool {
    // Opening a Realm fails if the file is inaccessible on the file
    // system, it has a different schema version, it is encrypted
    // and you don't provide matching credentials or the virtual
    // address space is exhausted. If you don't provide explicit
    // error handling for any of this cases at this place, then
    // you can open the Realm by a force-try without hesitation.
    let realm = try! Realm()
    // Write transactions are mutually exclusive. So starting the
    // transaction before checking whether an object with the same
    // primary key already exists, ensures that such an object
    // can't be concurrently created by any other thread.
    realm.beginWrite()
    if let _ = realm.objectForPrimaryKey(Article, article.id) {
         // Object exists already.
         realm.cancelWrite()
         return false;
    }
    realm.add(article)
    // Write transactions fail if it would cause the file to
    // outgrow the virtual address space or the disk capacity.
    // If you don't provide explicit error handling for this case
    // at this place, then you can commit the write transaction
    // by a force-try without hesitation.
    try! realm.commitWrite()
    return true
}
