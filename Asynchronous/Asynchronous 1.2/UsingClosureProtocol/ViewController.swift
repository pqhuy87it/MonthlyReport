//
//  ViewController.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var taylorSwiftSongs = [SongModel]()
    private var westlifeSongs = [SongModel]()
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusProgressView: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    var syncTask: AsyncTask!
    var tableViewSections = [TableViewSectionDataSource]()
    let songDataProvider = SongDataProvider()

    var songs = [SongModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getDataSong() {
        self.updateTextStatus("Downloading Taylor Swift ... ", progress: 0.0).then{
                self.songDataProvider.getTaylorSwiftSongs2()
            }.then { songs in
                self.completeLoadTaylorSwiftSong(songs)
            }.then {
                self.updateTextStatus("Downloading Westlife ...", progress: 0.5)
            }.then {
                self.songDataProvider.getWestlifeSongs2()
            }.then { songs in
                self.completeLoadWestlifeSong(songs)
            }.then {
                self.updateTextStatus("Done", progress: 0.0)
        }
        
//            .then{ _ in
//                self.songDataProvider.getTaylorSwiftSongs2()
//                    .then { songs in
//                        self.completeLoadTaylorSwiftSong(songs)
//                    }.then {
//                        self.updateTextStatus("Downloading Westlife ...", progress: 0.5)
//                    }.then {
//                        self.songDataProvider.getTaylorSwiftSongs2()
//                    }.then { songs in
//                        self.completeLoadWestlifeSong(songs)
//                }
    }
    
    func completeLoadTaylorSwiftSong(songs: [SongModel]) {
        self.songs.removeAll()
        self.songs.appendContentsOf(songs)
        self.tableView.reloadData()

    }
    
    func completeLoadWestlifeSong(songs: [SongModel]) {
        self.songs.appendContentsOf(songs)
        self.tableView.reloadData()
    }
    
    func updateTextStatus(status: String, progress: Float) -> Promise<Void> {
        return Promise { success, failure in
            self.statusLabel.text = status
            self.statusProgressView.progress = progress
            self.tableView.reloadData()
            success()
        }
    }
    
    func updateStatus(text: String, progress: Float = 0.0, reload: Bool = true) -> Action{
        return {
            self.statusLabel.text = text
            self.statusProgressView.progress = progress
            
            if reload {
                self.tableView.reloadData()
            }
        }
    }
    


    @IBAction func btnSyncPressed(sender: AnyObject) {
        getDataSong()
    }
}

//*****************************************************************
// MARK: - UITableViewDataSource
//*****************************************************************

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.trackName
        return cell
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return tableViewSections[section].sectionName
//    }
}

