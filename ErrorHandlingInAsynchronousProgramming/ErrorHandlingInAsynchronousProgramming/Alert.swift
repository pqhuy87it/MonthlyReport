//
//  Alert.swift
//  WhytPlot
//
//  Created by Exlinct on 5/23/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation
import UIKit

final class Alert {
    class func alert(title title: String, message: String?, dismissTitle: String, inViewController viewController: UIViewController?, withDismissAction dismissAction: (() -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let action: UIAlertAction = UIAlertAction(title: dismissTitle, style: .Default) { action -> Void in
                if let dismissAction = dismissAction {
                    dismissAction()
                }
            }
            alertController.addAction(action)
            
            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    class func alertError(message: String?, inViewController viewController: UIViewController?, withDismissAction dismissAction: (() -> Void)?) {
        dispatch_async(dispatch_get_main_queue()) {
            
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
            
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                if let dismissAction = dismissAction {
                    dismissAction()
                }
            }
            alertController.addAction(action)
            
            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}