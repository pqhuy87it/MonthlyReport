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

    let switchToMainThread: AsyncTask = { (action) -> Void in
        dispatch_async(dispatch_get_main_queue(), action)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getDataSong() {
        let syncTaylorSwiftSong: AsyncTask = switchToMainThread |>
                                             updateStatus("Download TaylorSwift Song ...") |>
                                             getTaylorSwiftSong
        
        let syncWestlifeSong: AsyncTask = switchToMainThread |>
                                          updateStatus("Download Westlife Song...") |>
                                          getWestlifeSong
        
        let endSync: Action = switchToMainThread |>
                              updateStatus("Done!")
        
        let task: Action = syncTaylorSwiftSong |>
                           syncWestlifeSong |>
                           endSync
        task()
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
    
    func getTaylorSwiftSong(completion: Action) {
        AppServices.getSongByArtist("TaylorSwift", failureHandler: { (reason, errorMessage) in
                print(errorMessage)
            }, completion: {[weak self] songs in
                if let songs = songs {
                    self?.taylorSwiftSongs.removeAll()
                    self?.taylorSwiftSongs.appendContentsOf(songs)
                    completion()
                }
        })
    }
    
    func getWestlifeSong(completion: Action) {
        AppServices.getSongByArtist("Westlife", failureHandler: { (reason, errorMessage) in
            print(errorMessage)
            }, completion: {[weak self] songs in
                if let songs = songs {
                    self?.westlifeSongs.removeAll()
                    self?.westlifeSongs.appendContentsOf(songs)
                    completion()
                }
            })
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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? taylorSwiftSongs.count : westlifeSongs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            let song = taylorSwiftSongs[indexPath.row]
            cell.textLabel?.text = song.trackName
        } else {
            let song = westlifeSongs[indexPath.row]
            cell.textLabel?.text = song.trackName
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "TaylorSwift" : "Westlife"
    }
}

