public extension UIApplication {
    public var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }

    public var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
}

UIApplication.shared.topViewController
