https://gist.github.com/romanwb/9bb468797e56f352e6f1117030591f2b

class Settings {
    static let shared = Settings()
    
    private let manager = UserDefaults.standard
    
    enum List: String {
        case notify
        case nightMode
    }

    private init() {
        registerDefault(.notify, value: true)
        registerDefault(.nightMode, value: true)
    }
    
    private func registerDefault(_ key: List, value: Bool) {
        manager.register(defaults: [key.rawValue: value])
    }
    
    func get(_ key: List) -> Bool {
        return manager.bool(forKey: key.rawValue)
    }
    
    func set(_ key: List, value: Bool) {
        manager.set(value, forKey: key.rawValue)
    }
}

// Usage
let settings = Settings.shared
settings.get(.notify)
settings.set(.nightMode, true)
