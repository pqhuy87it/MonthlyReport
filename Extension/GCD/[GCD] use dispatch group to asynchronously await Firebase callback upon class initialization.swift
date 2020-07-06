https://stackoverflow.com/questions/58037979/how-to-use-dispatch-group-to-asynchronously-await-firebase-callback-upon-class-i

func createUser(for userId: String, completion: @escaping (User) -> Void) {
    var pictureUrl: URL?
    var fullName: String?

    let group = DispatchGroup()

    group.enter()
    getFirebaseNameString(userId: userId) { name in
        fullName = name
        group.leave()
    }

    group.enter()
    getFirebasePictureURL(userId: userId) { url in
        pictureUrl = url
        group.leave()
    }

    group.notify(queue: .main) {
        guard
           let pictureUrl = pictureUrl, 
           let fullName = fullName 
        else { return }

        completion(User(uid: userId, fullName: fullName, pictureURL: pictureUrl))
    }
}

let userId = ...
createUser(for: userId) { user in 
    // use `User` instance here, e.g. creating your new node
}

class User {
    let uid: String
    let fullName: String
    let pictureURL: URL

    init(uid: String, fullName: String, pictureURL: URL) {
        self.uid = uid
        self.fullName = fullName
        self.pictureURL = pictureURL
    }
}
