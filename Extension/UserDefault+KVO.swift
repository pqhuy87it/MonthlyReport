struct UDKeyValueObservedChange<Value> {
    typealias Kind = NSKeyValueChange
    let kind: Kind
    let newValue: Value?
    let oldValue: Value?
    let indexes: IndexSet?
    let isPrior:Bool
}

class UDKeyValueObservation: NSObject {
    // 循環参照を避けるために監視オブジェクトは弱参照
    weak var object: NSObject?
    // 値変更時に実行するクロージャ(初期化時のクロージャ)
    let callback: (NSObject, UDKeyValueObservedChange<Any>) -> Void
    // 監視するUserDefaultsのキー
    let defaultName: String

    // 本家では KeyPath → String 変換が行われる
    fileprivate init(object: NSObject, defaultName: String, callback: @escaping (NSObject, UDKeyValueObservedChange<Any>) -> Void) {
        self.object = object
        self.defaultName = defaultName
        self.callback = callback
    }

    // 値の変更はまずここに通知される
    // 本家では, 黒魔術(method_exchangeImplementations)で独自関数と入れ替えてる
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard
            let ourObject = self.object,
            let change = change,
            object as? NSObject == ourObject,
            keyPath == defaultName
        else { return }

        // [NSKeyValueChangeKey: Any] => UDKeyValueObservedChange
        let rawKind = change[.kindKey] as! UInt
        let kind = NSKeyValueChange(rawValue: rawKind)!
        let notification = UDKeyValueObservedChange(kind: kind,
                                          newValue: change[.newKey],
                                          oldValue: change[.oldKey],
                                          indexes: change[.indexesKey] as! IndexSet?,
                                          isPrior: change[.notificationIsPriorKey] as? Bool ?? false)
        // クロージャを実行
        callback(ourObject, notification)
    }

    // 監視を開始
    // イニシャライザで行わないのは, options　に .initial が含まれていた場合, 自身の初期化前に通知されてしまうため（だと思われる）.
    fileprivate func start(_ options: NSKeyValueObservingOptions) {
        object?.addObserver(self, forKeyPath: defaultName, options: options, context: nil)
    }

    // 監視を解除.
    // deinit 時に自動で呼ばれると言いつつそれぞれ解除処理してる.
    func invalidate() {
        object?.removeObserver(self, forKeyPath: defaultName, context: nil)
        object = nil
    }

    deinit {
        object?.removeObserver(self, forKeyPath: defaultName, context: nil)
    }
}

typealias UDChangeHandler<O, V> = (O, UDKeyValueObservedChange<V>) -> Void

// KeyPathの方は _KeyValueCodingAndObserving プロトコルが定義されている
protocol UDKeyValueCodingAndObserving {}

extension UDKeyValueCodingAndObserving {
    func observe<Value>(_ type: Value.Type, forKey defaultName: String, options: NSKeyValueObservingOptions = [], changeHandler: @escaping UDChangeHandler<Self, Value>) -> UDKeyValueObservation {
        let result = UDKeyValueObservation(object: self as! NSObject, defaultName: defaultName) { obj, change in
            let notification = UDKeyValueObservedChange(kind: change.kind, newValue: change.newValue as? Value, oldValue: change.oldValue as? Value, indexes: change.indexes, isPrior: change.isPrior)
            changeHandler(obj as! Self, notification)
        }
        result.start(options)
        return result
    }
}

extension UserDefaults: UDKeyValueCodingAndObserving {}

class Hoge {
    var observation: UDKeyValueObservation?

    init() {
        observation = UserDefaults.standard.observe(String.self, forKey: "key-1", options: [.new, .old]) { _, change in
            print(change)
        }
    }
}

var hoge = Hoge()
print("1")
UserDefaults.standard.set("hoge", forKey: "key-1")
print("2")
UserDefaults.standard.set("hoge", forKey: "key-1")
print("3")
UserDefaults.standard.set("fuga", forKey: "key-1")
print("4")
UserDefaults.standard.set(nil, forKey: "key-2")
print("5")
hoge.observation = nil
UserDefaults.standard.set("hoge", forKey: "key-1")

// 1
// Hoge Optional("hoge") nil
// Hoge Optional("hoge") nil
// 2
// 3
// Hoge Optional("fuga") Optional("hoge")
// Hoge Optional("fuga") Optional("hoge")
// 4
// Hoge nil Optional("fuga")
// Hoge nil Optional("fuga")
// 5
