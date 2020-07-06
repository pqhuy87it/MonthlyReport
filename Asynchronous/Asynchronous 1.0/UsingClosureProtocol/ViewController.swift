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
        
        self.statusLabel.text = "Downloading Taylor Swift Songs ..."
        self.statusProgressView.progress = 0.0
        
        songDataProvider.getTaylorSwiftSongs({ songData in
            do {
                let songs = try songData.resolve()
                self.songs.removeAll()
                self.songs.appendContentsOf(songs)
                self.tableView.reloadData()
            } catch {
                
            }
        })
        
        self.statusLabel.text = "Downloading Westlife Songs ..."
        self.statusProgressView.progress = 0.5
        
        songDataProvider.getWestlifeSongs({ songData in
            do {
                let songs = try songData.resolve()
                self.songs.appendContentsOf(songs)
                self.tableView.reloadData()
            } catch {
                
            }
        })
        
        self.statusLabel.text = "Done"
        self.statusProgressView.progress = 0.0
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

