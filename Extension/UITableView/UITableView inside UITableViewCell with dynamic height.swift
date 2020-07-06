https://stackoverflow.com/questions/46441711/uitableview-inside-uitableviewcell-with-dynamic-height

https://stackoverflow.com/questions/36806297/uitableview-inside-uitableviewcell-with-dynamic-cell-height

class OwnTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
}

class StoryboardViewContrtoller: UIViewController {
    
    @IBOutlet weak var tableView: OwnTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension StoryboardViewContrtoller: UITableViewDelegate {
    
}

extension StoryboardViewContrtoller: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: indexPath) as! FirstTableViewCell
        return cell
    }
    
}

class FirstTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableView: OwnTableView!
    
    var number: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FirstTableViewCell: UITableViewDelegate {
    
}

extension FirstTableViewCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nil == number {
            number = 1 + Int(arc4random_uniform(UInt32(10 - 1 + 1)))
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyboardSecondCellId", for: indexPath) as! CellWithLabel
        cell.setupData(number: indexPath.row)
        cell.layoutIfNeeded()
        return cell
    }
}

class CellWithLabel: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = ""
    }
    
    func setupData(number: Int) {
        label.text = ""
        for _ in 0...number {
            label.text?.append("Some text without context ")
        }
    }
}
