//
//  TaylorSwiftSongDataProvider.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

class TaylorSwiftSongDataProvider {
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

