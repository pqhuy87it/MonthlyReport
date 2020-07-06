https://stackoverflow.com/questions/38029917/realmswift-transaction-completion

let realm = try! Realm()
let object = SomeObject()

try! realm.write(
        transactionBlock: {
            realm.add(object)
        },
        completion: {
            print("Write transaction finished")
})
    
DispatchQueue.main.async {
    try! self.realm.write {
        self.realm.add(friendInfo, update: true)
    }

    callbackFunction()
}
