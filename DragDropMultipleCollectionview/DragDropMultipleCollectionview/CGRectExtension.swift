//
//  CGRectExtension.swift
//  DragDropMultipleCollectionview
//
//  Created by Huy Pham Quang on 9/19/18.
//  Copyright © 2018 みかん方や. All rights reserved.
//

import Foundation
import UIKit

extension CGRect: Comparable {

    public var area: CGFloat {
        return self.size.width * self.size.height
    }

    public static func <=(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.area <= rhs.area
    }
    public static func <(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.area < rhs.area
    }
    public static func >(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.area > rhs.area
    }
    public static func >=(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.area >= rhs.area
    }
}
