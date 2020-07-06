//
//  ViewController.swift
//  UsingClosureProtocol
//
//  Created by Exlinct on 9/18/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {
    
    private var taylorSwiftSongs = [SongModel]()
    private var westlifeSongs = [SongModel]()
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusProgressView: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    var syncTask: AsyncTask!
    var tableViewSections = [TableViewSectionDataSource]()
    
    let promiseKitTaylorSwiftDataProvider = PromiseKitTayloSwiftSongDataProvider()
    let promiseKitWestliftDataProvider = PromiseKitWestlifeSongDataProvider()

    let switchToMainThread: AsyncTask = { (action) -> Void in
        dispatch_async(dispatch_get_main_queue(), action)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getDataSong() {
        addTableViewSection(TaylorSwiftSongDataProvider(), updatingText: "Download TaylorSwift Song ...")
        addTableViewSection(WestlifeSongDataProvider(), updatingText: "Download Westlife Song...")
        
        guard let performSync = self.syncTask else {
            return
        }
        
        let resetProgress: Action = {
            [unowned self] in
            self.statusProgressView.progress = 0.0
        }
        
        let endSync: Action = switchToMainThread |>
            resetProgress |>
            updateStatus("Done!")
        let task: Action = performSync |> endSync
        task()
    }
    
    func getDataSongPromiseKit() {
        statusLabel.text = "Download TaylorSwift Song ..."
        statusProgressView.progress = 0.0
        
        firstly {
            promiseKitTaylorSwiftDataProvider.loadSong()
            }.then { songs in
                self.reloadTaylorSwiftSong(songs)
            }.then {
                self.promiseKitWestliftDataProvider.loadSong()
            }.then { songs in
                self.reloadWestlifeSong(songs)
            }.error { error in
                print(error)
        }
    }
    
    func reloadTaylorSwiftSong(songs: [SongModel]) {
        taylorSwiftSongs = songs
        statusLabel.text = "Download Westlife Song..."
        statusProgressView.progress = 0.5
        tableView.reloadData()
    }
    
    func reloadWestlifeSong(songs: [SongModel]) {
        westlifeSongs = songs
        statusLabel.text = "Done!"
        statusProgressView.progress = 0.0
        tableView.reloadData()
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
    
    func addTableViewSection<T: TableViewSectionDataSource where T: Synchronizable>(section: T, updatingText: String) {
        self.tableViewSections.append(section)
        
        if let preSyncTask = self.syncTask {
            let index = self.tableViewSections.count - 1
            let updateProgress: Action = { [unowned self] in
                let progress = Float(index) / Float(self.tableViewSections.count)
                self.statusProgressView.progress = progress
            }
            
            self.syncTask = preSyncTask |>
                switchToMainThread |>
                updateStatus(updatingText) |>
                updateProgress |>
                section.synchronize
        } else {
            self.syncTask = switchToMainThread |>
                updateStatus(updatingText, reload: false) |>
                section.synchronize
        }
    }

    @IBAction func btnSyncPressed(sender: AnyObject) {
//        getDataSong()
        getDataSongPromiseKit()
    }
}

//*****************************************************************
// MARK: - UITableViewDataSource
//*****************************************************************

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return tableViewSections.count
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableViewSections[section].rowCount
        return (section == 0) ? taylorSwiftSongs.count : westlifeSongs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
//        let tableViewSection = tableViewSections[indexPath.section]
//        cell.textLabel?.text = tableViewSection[indexPath.row]
        if indexPath.section == 0 {
            let song = taylorSwiftSongs[indexPath.row]
            cell.textLabel?.text = "\(song.artistId)" + song.artistName!
        } else {
            let song = westlifeSongs[indexPath.row]
            cell.textLabel?.text = "\(song.artistId)" + song.artistName!
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return tableViewSections[section].sectionName
        return (section == 0) ? "TaylorSwift" : "Westlife"
    }
}

