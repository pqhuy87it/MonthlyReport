func processFile(url:NSURL) {
    let yearKey = -1453039239
    let genreKey = -1452841618
    let encoderKey = -1451987089
    let trackKey = "com.apple.iTunes.iTunes_CDDB_TrackNumber"
    let CDDBKey = "com.apple.iTunes.iTunes_CDDB_1"
    let path:String = url.absoluteString
    let asset = AVURLAsset(URL: url, options: nil)
    let format = AVMetadataFormatiTunesMetadata


    for item:AVMetadataItem in asset.metadataForFormat(format) as Array<AVMetadataItem> {

        if let key = item.commonKey { if key == "title" { println(item.value()) } }
        if let key = item.commonKey { if key == "artist" { println(item.value()) } }
        if let key = item.commonKey { if key == "albumName" { println(item.value()) } }
        if let key = item.commonKey { if key == "creationDate" { println(item.value()) } }
        if let key = item.commonKey { if key == "artwork" { println( "art" ) } }

        if item.key().isKindOfClass(NSNumber) {
            if item.key() as NSNumber == yearKey { println("year: \(item.numberValue)") }
            if item.key() as NSNumber == genreKey { println("genre: \(item.stringValue)") }
            if item.key() as NSNumber == encoderKey { println("encoder: \(item.stringValue)") }
        }

        if item.key().isKindOfClass(NSString) {
            if item.key() as String == trackKey { println("track: \(item.stringValue)") }
            if item.key() as String == CDDBKey { println("CDDB: \(item.stringValue)") }
        }
    }
}
