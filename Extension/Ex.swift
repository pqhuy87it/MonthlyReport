public struct TargetedExtension<Base> {
    let base: Base
    init (_ base: Base) {
        self.base = base
    }
}

public protocol TargetedExtensionCompatible {
    associatedtype Compatible
    static var ex: TargetedExtension<Compatible>.Type { get }
    var ex: TargetedExtension<Compatible> { get }
}

public extension TargetedExtensionCompatible {
    public static var ex: TargetedExtension<Self>.Type {
        return TargetedExtension<Self>.self
    }

    public var ex: TargetedExtension<Self> {
        return TargetedExtension(self)
    }
}


// UIViewに.exを増やす場合
extension UIView: TargetedExtensionCompatible {}

private extension TargetedExtension where Base: UIView {
    func foo() {}
}

UIView().ex.foo()
