https://stackoverflow.com/questions/3504173/detect-retina-display

extension UIScreen {

    public var isRetina: Bool {
        guard let scale = screenScale else {
            return false
        }
        return scale >= 2.0
    }

    public var isRetinaHD: Bool {
        guard let scale = screenScale else {
            return false
        }
        return scale >= 3.0
    }

    private var screenScale: CGFloat? {
        guard UIScreen.main.responds(to: #selector(getter: scale)) else {
            return nil
        }
        return UIScreen.main.scale
    }
}
