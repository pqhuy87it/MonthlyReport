public enum StoryboardInstantiateType {
    case initial
    case identifier(String)
}

public protocol StoryboardInstantiatable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle { get }
    static var instantiateType: StoryboardInstantiateType { get }
}

public extension StoryboardInstantiatable where Self: NSObject {
    public static var storyboardName: String {
        return className
    }

    public static var storyboardBundle: Bundle {
        return Bundle(for: self)
    }

    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    }

    public static var instantiateType: StoryboardInstantiateType {
        return .identifier(className)
    }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    public static func instantiate() -> Self {
        switch instantiateType {
        case .initial:
            return storyboard.instantiateInitialViewController() as! Self
        case .identifier(let identifier):
            return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        }
    }
}

// クラス名とStoryboard名、Storyboard IDが同じ
final class ViewController: UIViewController, StoryboardInstantiatable {
}

ViewController.instantiate()

// Is Initial View Controllerにチェックを入れている & クラス名とStoryboard名が同じ
final class InitialViewController: UIViewController, StoryboardInstantiatable {
    static var instantiateType: StoryboardInstantiateType {
        return .initial
    }
}

InitialViewController.instantiate()