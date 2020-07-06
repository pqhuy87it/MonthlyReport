//
//  TaylorSwiftSongDataProvider.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

class TaylorSwiftSongDataProvider: Synchronizable {
    typealias Element = SongModel
    private(set) var items = [SongModel]()
    
    func synchronize(completion: Action) {
        AppServices.getSongByArtist("TaylorSwift", failureHandler: { (reason, errorMessage) in
            print(errorMessage)
            }, completion: {[weak self] songs in
                if let songs = songs {
                    self?.items.removeAll()
                    self?.items.appendContentsOf(songs)
                    completion()
                }
            })
    }
}

extension TaylorSwiftSongDataProvider: TableViewSectionDataSource {
    var sectionName: String {
        return "Taylor Swift"
    }
    
    var rowCount: Int {
        return items.count
    }
    
    subscript(i: Int) -> String {
        return self.items[i].trackName!
    }
}