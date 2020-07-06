let realm = try Realm()
try realm.write {
   realm.delete(realm.objects(Uploading.self))
}

let realm = Realm()
let deletedValue = "two"
realm.write {
  let deletedNotifications = realm.objects(Notifications).filter("value == %@", deletedValue)
  realm.delete(deletedNotifications)
}

func removeVideos(at indexes: [Int]) {
    let newVideos = [Video]()
    for (index, video) in favorite!.videos.enumerated() {
        if !indexes.contains(index) {
            newVideos.append(video)
        }
    }

    let realm = try! Realm()
    try! realm.write {
        realm.delete(newVideos)
    }
}

func realmDeleteAllClassObjects() {
    do {
        let realm = try Realm()

        let objects = realm.objects(SomeClass.self)

        try! realm.write {
            realm.delete(objects)
        }
    } catch let error as NSError {
        // handle error
        print("error - \(error.localizedDescription)")
    }
}

func realmDelete(code: String) {

    do {
        let realm = try Realm()

        let object = realm.objects(SomeClass.self).filter("code = %@", code).first

        try! realm.write {
            if let obj = object {
                realm.delete(obj)
            }
        }
    } catch let error as NSError {
        // handle error
        print("error - \(error.localizedDescription)")
    }
}
