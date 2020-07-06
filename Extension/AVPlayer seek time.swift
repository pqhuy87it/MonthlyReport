https://stackoverflow.com/questions/11462843/avplayer-seektotime-does-not-play-at-correct-position

let playerTimescale = self.player.currentItem?.asset.duration.timescale ?? 1
let time =  CMTime(seconds: 77.000000, preferredTimescale: playerTimescale)
self.player.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero) { (finished) in /* Add your completion code here */
}
