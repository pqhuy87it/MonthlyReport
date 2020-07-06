//
//  AppServices.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AppServices {
    static func getSongByArtist(artistName: String, failureHandler: FailureHandler?, completion: [SongModel]? -> Void) {
        let url = "https://itunes.apple.com/search?media=music&entity=song&term=\(artistName)"
        
        Alamofire.request(.GET, url)
            .responseJSON{ response in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    
                    if let songDataArray = json["results"].array {
                        var songs = [SongModel]()
                        
                        for songData: JSON in songDataArray {
                            if let
                                    trackId = songData["trackId"].int,
                                    trackName = songData["trackName"].string,
                                    artistId = songData["artistId"].int,
                                    artistName = songData["artistName"].string {
                                let song = SongModel(trackId: trackId, trackName: trackName, artistId: artistId, artistName: artistName)
                                songs.append(song)
                            }
                        }
                        
                        completion(songs)
                    } else {
                        failureHandler!(reason: .Other(nil),errorMessage: "Parameter is incorrect!")
                    }
                case .Failure(let error):
                    print(error)
                    failureHandler!(reason: .Other(nil), errorMessage: "error!")
                }
        }
    }
}