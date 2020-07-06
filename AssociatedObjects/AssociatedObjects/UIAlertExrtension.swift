//
//  UIAlertExrtension.swift
//  AssociatedObjects
//
//  Created by Huy Pham on 5/28/17.
//  Copyright © 2017 Huy Pham. All rights reserved.
//

import UIKit

extension UIAlertView {
    struct PropertyKeys {
        static var DeleteKey = "Delete Key"
    }
    
    var indexPathToDelete: NSIndexPath? {
        get {
            if let indexPath = objc_getAssociatedObject(self, &PropertyKeys.DeleteKey) as? NSIndexPath {
                return indexPath
            }
            
            return nil
        }
        set {
            objc_setAssociatedObject(self, &PropertyKeys.DeleteKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}