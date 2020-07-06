//
//  PhotoViewController.swift
//  PhotoViewController
//
//  Created by Pham Quang Huy on 1/28/18.
//  Copyright © 2018 Pham Quang Huy. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var scalingImageView: ScalingImageView = {
        let view = ScalingImageView(frame: self.view.bounds)
        view.delegate = self
        return view
    }()
    
    var photo: Photo?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initImageView()
        self.initComponents()
    }

    fileprivate func initImageView() {
        self.scalingImageView.frame = self.view.bounds
        self.scalingImageView.image = self.photo?.image
        
        self.view.insertSubview(scalingImageView, belowSubview: self.topView)
        
        self.photo?.updatedImage = {[weak self] image in
            guard let weakSelf = self else { return }
            
            weakSelf.scalingImageView.image = image
            
            if image != nil {
                weakSelf.activityIndicator.stopAnimating()
            }
        }
        
        if self.photo?.image == nil {
            self.activityIndicator.startAnimating()
        }
    }
    
    fileprivate func initComponents() {
        // double tap gesture
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.addTarget(self, action: #selector(PhotoViewController.didDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGesture)
        self.view.tintColor = UIColor.white
        self.view.backgroundColor = UIColor.black
        
        self.modalPresentationStyle = .custom
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.activityIndicator.isHidden = true
    }

    @objc fileprivate func  didDoubleTap(_ sender: UITapGestureRecognizer) {
        let scrollViewSize = self.scalingImageView.bounds.size
        var pointInView = sender.location(in: self.scalingImageView.imageView)
        var newZoomScale = min(scalingImageView.maximumZoomScale, self.scalingImageView.minimumZoomScale * 2)
        
        if let imageSize = scalingImageView.imageView.image?.size, (imageSize.height / imageSize.width) > (scrollViewSize.height / scrollViewSize.width) {
            pointInView.x = scalingImageView.imageView.bounds.width / 2
            let widthScale = scrollViewSize.width / imageSize.width
            newZoomScale = widthScale
        }
        
        let isZoomIn = (scalingImageView.zoomScale >= newZoomScale) || (abs(scalingImageView.zoomScale - newZoomScale) <= 0.01)
        
        if isZoomIn {
            newZoomScale = scalingImageView.minimumZoomScale
        }
        
        scalingImageView.isDirectionalLockEnabled = !isZoomIn
        
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let originX = pointInView.x - (width / 2)
        let originY = pointInView.y - (height / 2)
        
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        self.scalingImageView.zoom(to: rectToZoomTo, animated: true)
    }
    
    // MARK: IBActions
    
    @IBAction func btnClosePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scalingImageView.imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.panGestureRecognizer.isEnabled = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.panGestureRecognizer.isEnabled = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
