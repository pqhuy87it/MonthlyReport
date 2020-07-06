//
//  ViewController.swift
//  AssociatedObjects
//
//  Created by Huy Pham on 5/28/17.
//  Copyright © 2017 Huy Pham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Traiditional Way"
        case 1:
            cell?.textLabel?.text = "Associated Object Way"
        case 2:
            cell?.textLabel?.text = "Awesome Way"
        default:
            break
        }
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.performSegueWithIdentifier("pushTraditionalVC", sender: self)
        } else if indexPath.row == 1 {
            self.performSegueWithIdentifier("pushAssociatedObjectVC", sender: self)
        } else {
            self.performSegueWithIdentifier("pushAwesomeWayVC", sender: self)
        }
    }
}

