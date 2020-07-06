//
//  AwesomeWayViewController.swift
//  AssociatedObjects
//
//  Created by Huy Pham on 5/28/17.
//  Copyright © 2017 Huy Pham. All rights reserved.
//

import UIKit

class AwesomeWayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items = [People]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // create data
        items = [People(name: "Huy", age: 30), People(name: "Tuan", age: 28), People(name: "Thanh", age: 31)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension AwesomeWayViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let people = items[indexPath.row]
        cell?.textLabel?.text = people.name
        cell?.selectionStyle = .None
        
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = UIAlertView(title: "Delete People",
                                    message: "Are you sure you want to delete this people ?",
                                    delegate: self,
                                    cancelButtonTitle: "Cancel",
                                    otherButtonTitles: "OK")
            alert.show()
            alert.indexPathToDelete = indexPath
        }
    }
}

extension AwesomeWayViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            guard let indexPath = alertView.indexPathToDelete else {
                return
            }
            
            self.items.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
}


