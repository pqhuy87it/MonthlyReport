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
        getDataSong()
    }
}

//*****************************************************************
// MARK: - UITableViewDataSource
//*****************************************************************

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSections[section].rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let tableViewSection = tableViewSections[indexPath.section]
        cell.textLabel?.text = tableViewSection[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSections[section].sectionName
    }
}

