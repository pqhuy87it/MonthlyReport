//
//  Photo.swift
//  PhotoViewController
//
//  Created by Pham Quang Huy on 1/28/18.
//  Copyright © 2018 Pham Quang Huy. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol PhotoProtocol: class {
    var image: UIImage? { get set }
    var updatedImage: ((_ image: UIImage?) -> Void)? { get set }
}

class Photo: NSObject, PhotoProtocol {
    var image: UIImage? {
        didSet {
            self.updatedImage?(image)
        }
    }
    
    var updatedImage: ((UIImage?) -> Void)?
    
    init(_ imageUrl: String) {
        super.init()
        
        if let url = URL(string: imageUrl) {
            let iamgeResouce = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: iamgeResouce, options: nil, progressBlock: nil, completionHandler: {[weak self](image, error, cacheType, imageURL) in
                guard let weakSelf = self else {
                    return
                }
                
                if let image = image {
                    weakSelf.image = image
                }
            })
        }
    }
}
