class ClassLabelSizeClass: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone5C:
            self.font = self.font.withSize(?*self.font.pointSize)
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            self.font = self.font.withSize(?*self.font.pointSize + 2)
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            self.font = self.font.withSize(?*self.font.pointSize + 2)
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
           self.font = self.font.withSize(?*self.font.pointSize + 3)
        default:
           self.font = self.font.withSize(?*self.font.pointSize + 4)
        }
    }
}
public enum EnumModel: String {
case simulator     = "simulator/sandbox",
//iPod
iPod1              = "iPod 1",
iPod2              = "iPod 2",
iPod3              = "iPod 3",
iPod4              = "iPod 4",
iPod5              = "iPod 5",
//iPad
iPad2              = "iPad 2",
iPad3              = "iPad 3",
iPad4              = "iPad 4",
iPadAir            = "iPad Air ",
iPadAir2           = "iPad Air 2",
iPad5              = "iPad 5", //aka iPad 2017
iPad6              = "iPad 6", //aka iPad 2018
//iPad mini
iPadMini           = "iPad Mini",
iPadMini2          = "iPad Mini 2",
iPadMini3          = "iPad Mini 3",
iPadMini4          = "iPad Mini 4",
//iPad pro
iPadPro9_7         = "iPad Pro 9.7\"",
iPadPro10_5        = "iPad Pro 10.5\"",
iPadPro12_9        = "iPad Pro 12.9\"",
iPadPro2_12_9      = "iPad Pro 2 12.9\"",
//iPhone
iPhone4            = "iPhone 4",
iPhone4S           = "iPhone 4S",
iPhone5            = "iPhone 5",
iPhone5S           = "iPhone 5S",
iPhone5C           = "iPhone 5C",
iPhone6            = "iPhone 6",
iPhone6plus        = "iPhone 6 Plus",
iPhone6S           = "iPhone 6S",
iPhone6Splus       = "iPhone 6S Plus",
iPhoneSE           = "iPhone SE",
iPhone7            = "iPhone 7",
iPhone7plus        = "iPhone 7 Plus",
iPhone8            = "iPhone 8",
iPhone8plus        = "iPhone 8 Plus",
iPhoneX            = "iPhone X",
iPhoneXS           = "iPhone XS",
iPhoneXSMax        = "iPhone XS Max",
iPhoneXR           = "iPhone XR",
//Apple TV
AppleTV            = "Apple TV",
AppleTV_4K         = "Apple TV 4K",
unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
public var type: EnumModel {
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            ptr in String.init(validatingUTF8: ptr)

        }
    }
    var modelMap : [ String: EnumModel ] = [
        "i386": .simulator,
        "x86_64": .simulator,
        //iPod
        "iPod1,1": .iPod1,
        "iPod2,1": .iPod2,
        "iPod3,1": .iPod3,
        "iPod4,1": .iPod4,
        "iPod5,1": .iPod5,
        //iPad
        "iPad2,1": .iPad2,
        "iPad2,2": .iPad2,
        "iPad2,3": .iPad2,
        "iPad2,4": .iPad2,
        "iPad3,1": .iPad3,
        "iPad3,2": .iPad3,
        "iPad3,3": .iPad3,
        "iPad3,4": .iPad4,
        "iPad3,5": .iPad4,
        "iPad3,6": .iPad4,
        "iPad4,1": .iPadAir,
        "iPad4,2": .iPadAir,
        "iPad4,3": .iPadAir,
        "iPad5,3": .iPadAir2,
        "iPad5,4": .iPadAir2,
        "iPad6,11": .iPad5, //aka iPad 2017
        "iPad6,12": .iPad5,
        "iPad7,5": .iPad6, //aka iPad 2018
        "iPad7,6": .iPad6,
        //iPad mini
        "iPad2,5": .iPadMini,
        "iPad2,6": .iPadMini,
        "iPad2,7": .iPadMini,
        "iPad4,4": .iPadMini2,
        "iPad4,5": .iPadMini2,
        "iPad4,6": .iPadMini2,
        "iPad4,7": .iPadMini3,
        "iPad4,8": .iPadMini3,
        "iPad4,9": .iPadMini3,
        "iPad5,1": .iPadMini4,
        "iPad5,2": .iPadMini4,
        //iPad pro
        "iPad6,3": .iPadPro9_7,
        "iPad6,4": .iPadPro9_7,
        "iPad7,3": .iPadPro10_5,
        "iPad7,4": .iPadPro10_5,
        "iPad6,7": .iPadPro12_9,
        "iPad6,8": .iPadPro12_9,
        "iPad7,1": .iPadPro2_12_9,
        "iPad7,2": .iPadPro2_12_9,
        //iPhone
        "iPhone3,1": .iPhone4,
        "iPhone3,2": .iPhone4,
        "iPhone3,3": .iPhone4,
        "iPhone4,1": .iPhone4S,
        "iPhone5,1": .iPhone5,
        "iPhone5,2": .iPhone5,
        "iPhone5,3": .iPhone5C,
        "iPhone5,4": .iPhone5C,
        "iPhone6,1": .iPhone5S,
        "iPhone6,2": .iPhone5S,
        "iPhone7,1": .iPhone6plus,
        "iPhone7,2": .iPhone6,
        "iPhone8,1": .iPhone6S,
        "iPhone8,2": .iPhone6Splus,
        "iPhone8,4": .iPhoneSE,
        "iPhone9,1": .iPhone7,
        "iPhone9,3": .iPhone7,
        "iPhone9,2": .iPhone7plus,
        "iPhone9,4": .iPhone7plus,
        "iPhone10,1": .iPhone8,
        "iPhone10,4": .iPhone8,
        "iPhone10,2": .iPhone8plus,
        "iPhone10,5": .iPhone8plus,
        "iPhone10,3": .iPhoneX,
        "iPhone10,6": .iPhoneX,
        "iPhone11,2": .iPhoneXS,
        "iPhone11,4": .iPhoneXSMax,
        "iPhone11,6": .iPhoneXSMax,
        "iPhone11,8": .iPhoneXR,
        //AppleTV
        "AppleTV5,3": .AppleTV,
        "AppleTV6,2": .AppleTV_4K
    ]

    if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
        if model == .simulator {
            if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                    return simModel
                }
            }
        }
        return model
    }
    return EnumModel.unrecognized
}
}
