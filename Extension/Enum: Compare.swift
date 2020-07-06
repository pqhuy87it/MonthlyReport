enum MyEnum {
    case None
    case Simple(text: String)
    case Advanced(x: Int, y: Int)
}

func ==(lhs: MyEnum, rhs: MyEnum) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None):
        return true
    case let (.Simple(v0), .Simple(v1)):
        return v0 == v1
    case let (.Advanced(x0, y0), .Advanced(x1, y1)):
        return x0 == x1 && y0 == y1
    default:
        return false
    }
}

enum CompassPoint: Equatable {
    case North
    case South
    case East
    case West
}

// Used to compare 'CompassPoint' enum
func ==<T : Equatable>(lhs: T?, rhs: T?) -> Bool

enum Barcode {
    case UPCA(Int, Int)
    case QRCode(String)
    case None
}

extension Barcode: Equatable {
}

func ==(lhs: Barcode, rhs: Barcode) -> Bool {
    switch (lhs, rhs) {
    case (let .UPCA(codeA1, codeB1), let .UPCA(codeA2, codeB2)):
        return codeA1 == codeA2 && codeB1 == codeB2

    case (let .QRCode(code1), let .QRCode(code2)):
        return code1 == code2

    case (.None, .None):
        return true

    default:
        return false
    }
}
