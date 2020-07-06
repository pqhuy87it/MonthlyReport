//
//  SongDataProvider.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 10/23/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

class SongDataProvider {
    func getTaylorSwiftSongs(complete: Result<[SongModel]> -> Void) {
        AppServices.getSongByArtist("TaylorSwift", failureHandler: { (reason, errorMessage) in
            print(errorMessage)
            }, completion: { songs in
                if let songs = songs {
                    complete(Result{ return  songs})
                }
            })
    }
    
    func getWestlifeSongs(complete: Result<[SongModel]> -> Void) {
        AppServices.getSongByArtist("Westlife", failureHandler: { (reason, errorMessage) in
            print(errorMessage)
            }, completion: { songs in
                if let songs = songs {
                    complete(Result { return songs })
                }
            })
    }
    
    func getTaylorSwiftSongs2() -> Promise<[SongModel]> {
        return Promise { complete, failure in
            AppServices.getSongByArtist("TaylorSwift", failureHandler: { (reason, errorMessage) in
                    let err = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 0, userInfo: nil)
                    failure(err)
                }, completion: { songs in
                    if let songs = songs {
                        complete(songs)
                    }
            })
        }
    }
    
    func getWestlifeSongs2() -> Promise<[SongModel]> {
        return Promise { complete, failure in
            AppServices.getSongByArtist("Westlife", failureHandler: { (reason, errorMessage) in
                print(errorMessage)
                }, completion: { songs in
                    if let songs = songs {
                        complete(songs)
                    }
            })
        }
    }
}