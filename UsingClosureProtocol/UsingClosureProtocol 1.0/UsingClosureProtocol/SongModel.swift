//
//  SongModel.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

class SongModel {
    var trackId: Int?
    var trackName: String?
    var artistId: Int?
    var artistName: String?
    
    init(trackId: Int, trackName: String, artistId: Int, artistName: String) {
        self.trackId = trackId
        self.trackName = trackName
        self.artistId = artistId
        self.artistName = artistName
    }
}