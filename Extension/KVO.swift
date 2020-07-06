public func observe<Value>(_ keyPath: KeyPath<Self, Value>, options: NSKeyValueObservingOptions = [], changeHandler: @escaping (Self, NSKeyValueObservedChange<Value>) -> Void) -> NSKeyValueObservation {
    let result = NSKeyValueObservation(object: self as! NSObject, keyPath: keyPath) { (obj, change) in
        let notification = NSKeyValueObservedChange(kind: change.kind, newValue: change.newValue as? Value, oldValue: change.oldValue as? Value, indexes: change.indexes, isPrior: change.isPrior)
        changeHandler(obj as! Self, notification)
    }
    result.start(options)
    return result
}

class Hoge {
    let scrollView = UIScrollView()
    var observation: NSKeyValueObservation?

    setUp() {
        observation = scrollView.observe(\.contentOffset) { view, change in
            print("move to (x: \(change.newValue!.x), y: \(change.newValue!.y))")
        }
    }

    tearDown() {
        observation.invalidate()
        // もしくは
        // observation = nil
        // もしくは自身(Hoge)の解放
    }
}


extension ObjectUserDefaultable {
    static func ovserve<Value>(_ type: Value.Type, forKey key: ObjectDefaultKey, changeHandler: @escaping UDChangeHandler<UserDefaults, Value>) -> UDKeyValueObservation {
        let key = namespace(key)
        return UserDefaults.standard.observe(type, forKey: key, changeHandler: changeHandler)
    }
}

extension IntegerUserDefaultable { /* 同様の実装 */ }

let observation = MyUserDefaults.observe(String.self, forKey: .userName) { defaults, change in
    print(change)
}
// 型が固定のキーは上記の第一引数は無くても良い
let observation2 = MyUserDefaults.observe(forKey: .needsBackup) { defaults, change in
    print(change)
}
    
protocol KeyValueObservationable {
    // 外から見えるのはこれだけでよい
    func invalidate()
}

extension NSKeyValueObservation: KeyValueObservationable {}
extension UDKeyValueObservation: KeyValueObservationable {}

// 使用例
var observations = [KeyValueObservationable]()
let observationNS = scrollView.observe(\.contentOffset) { ... }
let observationUD = userDefaults.observe("userName") { ... }
observations.append(contentsOf: [observationNS, observationUD])
    
class Hoge {
    let defaults: UserDefaultable

    init(defaults: UserDefaultable) {
        self.defaults = defaults
    }

    func save(value: Int) {
        defaults.set(value, forKey: "key")
    }
}

// 通常時
let hoge = Hoge(defaults: UserDefaults.standard)
// テスト時
let hoge = Hoge(defaults: UserDefaultsFake())
    
    
public protocol UserDefaultable: UDKeyValueCodingAndObserving {
    func object(forKey defaultName: String) -> Any?
    func string(forKey defaultName: String) -> String?
    ...

    func set(_ value: Any?, forKey defaultName: String)
    func set(_ value: Int, forKey defaultName: String)
    ...

    func removeObject(forKey defaultName: String)

    // これだけ自前で用意
    func reset()
}
    
extension UserDefaults: UserDefaultable {
    public func reset() {
        guard let bundleId = Bundle.main.bundleIdentifier else { return }
        removePersistentDomain(forName: bundleId)
    }
}
    
public class UserDefaultsFake: UserDefaultable {
    private var values = [String: Any]() // 値格納用

    // MARK: Getter --------------

    func object(forKey defaultName: String) -> Any? {
        return values[defaultName]
    }

    func string(forKey defaultName: String) -> String? {
        return values[defaultName] as? String
    }

    ...

    // MARK: Setter --------------

    func set(_ value: Any?, forKey defaultName: String) {
        guard let val = value else { removeObject(forKey: defaultName); return }
        values[defaultName] = val
    }

    func set(_ value: Int, forKey defaultName: String) {
        values[defaultName] = value
    }

    ...

    func reset() {
        values = [:]
    }
}
    
class Hoge {
    let defaults: UserDefaultable

    init(defaults: UserDefaultable) {
        self.defaults = defaults
    }

    func save(value: Int) {
        MyUserDefaults.set(value, forKey: .hogeKey, source: defaults)
    }
}
