https://stackoverflow.com/questions/54452589/how-to-expand-and-collapse-tableview-cells-with-dynamic-height-programmatically/54520672

class ViewController: UIViewController {
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100.0
        tv.estimatedSectionHeaderHeight = 0
        tv.estimatedSectionFooterHeight = 0
        tv.showsVerticalScrollIndicator = false
        tv.tableFooterView = UIView()
        tv.alwaysBounceVertical = true
        tv.decelerationRate = .fast
        tv.bounces = false
        return tv
    }()
    var selectedCell:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: ["tableView":tableView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: ["tableView":tableView]))
    }


}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell ?? CustomCell()
        if let selectedCell = selectedCell, selectedCell == indexPath {
            cell.descriptionLabel.isHidden = false
        } else {
            cell.descriptionLabel.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

class CustomCell: UITableViewCell {

    let stackView = UIStackView()
    let wordLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabels()
    }

    func setupLabels() {

        selectionStyle = .none

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)

        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lor"
        wordLabel.numberOfLines = 0
        wordLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(wordLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(descriptionLabel)

        wordLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true

        stackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor,constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor,constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor,constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor,constant: 10).isActive = true

    }
}
