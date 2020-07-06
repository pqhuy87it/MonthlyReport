 // https://stackoverflow.com/questions/10220958/avcapturedevice-camera-zoom
 
 @IBAction func pinchToZoom(_ pinch: UIPinchGestureRecognizer) {

    guard let device = captureDevice else { return }

    func minMaxZoom(_ factor: CGFloat) -> CGFloat { return min(max(factor, 1.0), device.activeFormat.videoMaxZoomFactor) }

    func update(scale factor: CGFloat) {
      do {
        try device.lockForConfiguration()
        defer { device.unlockForConfiguration() }
        device.videoZoomFactor = factor
      } catch {
        debugPrint(error)
      } 
    }

    let newScaleFactor = minMaxZoom(pinch.scale * zoomFactor)

    switch sender.state {
      case .began: fallthrough
      case .changed: update(scale: newScaleFactor)
      case .ended:
        zoomFactor = minMaxZoom(newScaleFactor)
        update(scale: zoomFactor)
     default: break
   }
 }
 
 --------------------
 
 // https://stackoverflow.com/questions/33180564/pinch-to-zoom-camera
 
 1. Define zoom levels.

let minimumZoom: CGFloat = 1.0
let maximumZoom: CGFloat = 3.0
var lastZoomFactor: CGFloat = 1.0

2. Add Pinch Gesture on CameraView.

let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch(_:)))        
            self.viewCamera.addGestureRecognizer(pinchRecognizer)
            
3. Pinch-action method with the logic of zoomin and zoom out

func pinch(_ pinch: UIPinchGestureRecognizer) {
        guard let device = videoDeviceInput.device else { return }

        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }

        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }

        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)

        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
