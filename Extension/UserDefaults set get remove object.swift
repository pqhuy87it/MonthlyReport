protocol KeyNamespaceable {}

extension KeyNamespaceable {
    static func namespace<T: RawRepresentable>(_ key: T) -> String where T.RawValue == String {
        return "\(Self.self)_\(T.self)_\(key.rawValue)"
    }
}

protocol ObjectUserDefaultable: KeyNamespaceable {
    associatedtype ObjectDefaultKey: RawRepresentable
}

extension ObjectUserDefaultable where ObjectDefaultKey.RawValue == String {
    static func set(_ value: Any?, forKey key: ObjectDefaultKey) {
        UserDefaults.standard.set(value, forKey: namespace(key))
    }

    static func object(for key: ObjectDefaultKey) -> Any? {
        return UserDefaults.standard.object(forKey: namespace(key))
    }

    static func remove(for key: ObjectDefaultKey) {
        UserDefaults.standard.removeObject(forKey: namespace(key))
    }
}

public protocol IntegerUserDefaultable: KeyNamespaceable { /*同様の実装*/ }

struct MyUserDefaults: ObjectUserDefaultable, BoolUserDefaultable {
    enum ObjectDefaultKey: String {
        case userName
        case appTheme
    }

    enum BoolDefaultKey: String {
        case needsBackup
    }
}

MyUserDefaults.set("krimpedance", forKey: .userName)
let needsBackup = MyUserDefaults.bool(forKey: .needsBackup)
