//
//  PromiseKitWestlifeSongDataProvider.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 10/8/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON

class PromiseKitWestlifeSongDataProvider {
    func loadSong() -> Promise<[SongModel]> {
        return Promise { complete, reject in
            let url = "https://itunes.apple.com/search?media=music&entity=song&term=Westlife"
            
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
                            
                            complete(songs)
                        } else {
                            reject(RequestErrors.RequestError)
                        }
                    case .Failure(let error):
                        print(error)
                        reject(RequestErrors.RequestError)
                    }
            }
        }
    }
}