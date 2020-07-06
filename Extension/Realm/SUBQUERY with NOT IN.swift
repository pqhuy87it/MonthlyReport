https://stackoverflow.com/questions/58237243/swift-nspredicate-subquery-with-not-in

class BreedClass: Object {
    @objc dynamic var breed = ""
}

class DogClass: Object {
    @objc dynamic var dog_id = NSUUID().uuidString
    @objc dynamic var dog_name = ""
    @objc dynamic var dog_breed: BreedClass?

    override static func primaryKey() -> String? {
        return "dog_id"
    }
}

class PersonClass: Object {
    @objc dynamic var person_id = UUID().uuidString
    @objc dynamic var first_name = ""

    let dogs = List<DogClass>()

    override static func primaryKey() -> String? {
        return "person_id"
    }
}

let b0 = BreedClass()
b0.breed = "Mut"

let b1 = BreedClass()
b1.breed = "Poodle"

let b2 = BreedClass()
b2.breed = "Hound"

let d2 = DogClass()
d2.dog_name = "Sasha"
d2.dog_breed = b2

let breed = "Hound"
let personResults = realm.objects(PersonClass.self).filter("NOT ANY dogs.dog_breed.breed == %@", breed)
for person in personResults {
    print(person.first_name)
}

and the output

Bert
Grover
The Count
