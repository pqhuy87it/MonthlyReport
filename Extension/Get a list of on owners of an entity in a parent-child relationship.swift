https://stackoverflow.com/questions/41502476/realm-adding-children-to-a-parent-then-querying-results-on-parent?rq=1

// Cut-down summary of Realm objects and relationships
public class Parent: Object {
  var children = List<Child>()
}
public class Child: Object {
  private let parents = LinkingObjects(fromType: Parent.self, property: "children")
  private let owners = LinkingObjects(fromType: Player.self, property: "children")
  var parent:Parent? {
      return self.parents.first
  }
  var owner: Player? {
      return self.owners.first
  }
}
public class Player : Object {
  public let children = List<Child>()
}



let realm = try! Realm()
self.createPlayers(amount: 5)
let playerList = realm.objects(EYPlayer.self)
XCTAssert(playerList.count == 5)

let firstParent = realm.objects(Parent.self).first
    let firstPlayer = realm.objects(Player.self).first
    let firstChild = firstParent?.children.first

    XCTAssert(firstChild?.parent == firstParent)

    try! realm.write {
        firstPlayer!.children.append(firstChild!)
    }

    let listOfChildren = realm.objects(Parent.self).filter("ANY children.owners.@count > 0")
    XCTAssert(listOfChildren.count == 1)
    XCTAssert(firstPlayer?.children.count == 1)

    for child in listOfChildren {
        for (index, eng) in child.children.enumerated() {
            if (index == 0) {
                XCTAssert(eng.owner != nil)
            }
            XCTAssert(child.parent == loco)
        }
    }
