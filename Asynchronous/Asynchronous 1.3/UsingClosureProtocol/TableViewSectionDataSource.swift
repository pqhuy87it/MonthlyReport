//
//  TableViewSectionDataSource.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

protocol TableViewSectionDataSource {
    var sectionName: String { get }
    var rowCount: Int { get }
    subscript(i: Int) -> String { get }
}