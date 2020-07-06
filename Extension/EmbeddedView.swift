public protocol EmbeddedNibInstantiatable {
    associatedtype Embedded: NibInstantiatable
}

public extension EmbeddedNibInstantiatable where Self: UIView, Embedded: UIView {
    public var embedded: Embedded { return subviews[0] as! Embedded }

    public func configureEmbededView() {
        let view = Embedded.instantiate()
        insertSubview(view, at: 0)
        view.fillSuperview() // 後述
    }
}

final class EmbeddedView: UIView, NibInstantiatable {
}

@IBDesignable
final class IBEmbeddedView: UIView, EmbeddedNibInstantiatable {
    typealias Embedded = EmbeddedView

    #if TARGET_INTERFACE_BUILDER
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureEmbededView()
    }
    #endif

    override func awakeFromNib() {
        super.awakeFromNib()
        configureEmbededView()
    }
}