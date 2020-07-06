//
//  SongDataProvider.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 10/23/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SongDataProvider {
    func getSongByArtist(artistName: String) -> Async<[SongModel]> {
        return Async { success, failure in
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
                            
                            success(songs)
                        } else {
                            failure(RequestErrors.CouldNotParseJSON)
                        }
                    case .Failure(let error):
                        if let err = error as? NSURLError where err == .NotConnectedToInternet {
                            failure(RequestErrors.NoInternetConnnection)
                        } else {
                            failure(RequestErrors.UnknowError)
                        }
                    }
            }
        }
    }
    
    func getTaylorSwiftSongs() -> Async<[SongModel]> {
        return getSongByArtist("TaylorSwift")
    }
    
    func getWestlifeSongs() -> Async<[SongModel]> {
        return getSongByArtist("Westlife")
    }
}