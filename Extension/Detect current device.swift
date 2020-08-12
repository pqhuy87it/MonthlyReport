https://stackoverflow.com/questions/24059327/detect-current-device-with-ui-user-interface-idiom-in-swift

struct Device {
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
}

if(Device.IS_IPHONE){
    // device is iPhone
}if(Device.IS_IPAD){
    // device is iPad (or a Mac running under macOS Catalyst)
}else{
    // other
}

public extension UIDevice {

    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    class var isTV: Bool {
        return UIDevice.current.userInterfaceIdiom == .tv
    }

    class var isCarPlay: Bool {
        return UIDevice.current.userInterfaceIdiom == .carPlay
    }
}
