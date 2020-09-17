https://stackoverflow.com/questions/34661793/setting-tableheaderview-height-dynamically

override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if let headerView = tableView.tableHeaderView {

        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var headerFrame = headerView.frame

        //Comparison necessary to avoid infinite loop
        if height != headerFrame.size.height {
            headerFrame.size.height = height
            headerView.frame = headerFrame
            tableView.tableHeaderView = headerView
        }
    }
}

-----

extension UITableView {
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
}

And call it like so:

override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView.updateHeaderViewHeight()
}

----

https://qiita.com/AkkeyLab/items/9864c741b9adb633b321
