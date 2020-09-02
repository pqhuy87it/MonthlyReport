https://stackoverflow.com/questions/26578023/animate-drawing-of-a-circle

let circleLayer: CAShapeLayer!

override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()

    // Use UIBezierPath as an easy way to create the CGPath for the layer.
    // The path should be the entire circle.
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)

    // Setup the CAShapeLayer with the path, colors, and line width
    circleLayer = CAShapeLayer()
    circleLayer.path = circlePath.CGPath
    circleLayer.fillColor = UIColor.clearColor().CGColor
    circleLayer.strokeColor = UIColor.redColor().CGColor
    circleLayer.lineWidth = 5.0;

    // Don't draw the circle initially
    circleLayer.strokeEnd = 0.0

    // Add the circleLayer to the view's layer's sublayers
    layer.addSublayer(circleLayer)
}

func animateCircle(duration: NSTimeInterval) {
    // We want to animate the strokeEnd property of the circleLayer
    let animation = CABasicAnimation(keyPath: "strokeEnd")

    // Set the animation duration appropriately
    animation.duration = duration

    // Animate from 0 (no circle) to 1 (full circle)
    animation.fromValue = 0
    animation.toValue = 1

    // Do a linear animation (i.e. the speed of the animation stays the same)
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

    // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
    // right value when the animation ends.
    circleLayer.strokeEnd = 1.0

    // Do the actual animation
    circleLayer.addAnimation(animation, forKey: "animateCircle")
}

func addCircleView() {
    let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
     var circleWidth = CGFloat(200)
     var circleHeight = circleWidth

        // Create a new CircleView
     var circleView = CircleView(frame: CGRectMake(diceRoll, 0, circleWidth, circleHeight))

     view.addSubview(circleView)

     // Animate the drawing of the circle over the course of 1 second
     circleView.animateCircle(1.0)
}
