import UIKit

class Border: UIView {
    
    override func draw(_ rect: CGRect) {

        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.move(to: CGPoint(x: rect.minX, y: rect.minY))
        cgContext?.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        cgContext?.setStrokeColor(UIColor.gray.cgColor)
        cgContext?.setLineWidth(0.5)
        cgContext?.strokePath()
    }
}
