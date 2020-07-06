https://medium.com/@m.muizzsuddin_25037/can-only-delete-an-object-from-the-realm-it-belongs-to-oh-what-swift-c17aee28171f

let predicate = NSPredicate(format: "UUID == %@", product.uuid)
if let productToDelete = realm.object(RMProduct.self)
                              .filter(predicate).first {
      realm.delete(productToDelete)
}
