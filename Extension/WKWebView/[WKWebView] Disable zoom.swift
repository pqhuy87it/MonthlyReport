// https://stackoverflow.com/questions/40452034/disable-zoom-in-wkwebview/41741125

override func viewDidLoad() {
         super.viewDidLoad()
         self.webView.scrollView.delegate = self
}

//MARK: - UIScrollViewDelegate
func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
         scrollView.pinchGestureRecognizer?.isEnabled = false
}

