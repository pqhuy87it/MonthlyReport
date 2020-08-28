https://stackoverflow.com/questions/24475792/how-to-use-pull-to-refresh-in-swift

var refreshControl = UIRefreshControl()

override func viewDidLoad() {
   super.viewDidLoad()

   refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
   refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
   tableView.addSubview(refreshControl) // not required when using UITableViewController
}

@objc func refresh(_ sender: AnyObject) {
   // Code to refresh table view  
}
