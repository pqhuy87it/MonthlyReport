//
//  ViewController.swift
//  ErrorHandlingInAsynchronousProgramming
//
//  Created by Exlinct on 10/29/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let songDataProvider = SongDataProvider()
    var songs = [SongModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getDataSong() {
        self.updateTextStatus("Downloading Taylor Swift ... ", progress: 0.0).then{
            self.songDataProvider.getTaylorSwiftSongs()
            }.then { songs in
                self.completeLoadTaylorSwiftSong(songs)
            }.then { _ in
                self.updateTextStatus("Downloading Westlife ...", progress: 0.5)
            }.then {
                self.songDataProvider.getWestlifeSongs()
            }.then { songs in
                self.completeLoadWestlifeSong(songs)
            }.then { _ in
                self.updateTextStatus("Done", progress: 0.0)
            }.error { error in
                self.handleError(error)
        }
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
    
    func handleError(error: ErrorType) -> Async<Void> {
        return Async { success, failure in
            if let error = error as? RequestErrors {
                switch error {
                case .CouldNotParseJSON:
                    Alert.alertError("Could not parse josn data!", inViewController: self, withDismissAction: {})
                case .NoInternetConnnection:
                    Alert.alertError("You are not connect to internet!", inViewController: self, withDismissAction: {})
                case .UnknowError:
                    Alert.alertError("Unknown error!", inViewController: self, withDismissAction: {})
                }
            }
            success()
        }
    }
    
    func updateTextStatus(status: String, progress: Float) -> Async<Void> {
        return Async { success, failure in
            self.statusLabel.text = status
            self.progressView.progress = progress
            self.tableView.reloadData()
            success()
        }
    }

    @IBAction func syncDataPressed(sender: AnyObject) {
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

