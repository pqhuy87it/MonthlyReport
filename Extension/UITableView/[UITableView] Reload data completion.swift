https://stackoverflow.com/questions/16071503/how-to-tell-when-uitableview-has-completed-reloaddata
class UITableViewWithReloadCompletion: UITableView {
  private var reloadDataCompletionBlock: (() -> Void)?

  override func layoutSubviews() {
    super.layoutSubviews()

    reloadDataCompletionBlock?()
    reloadDataCompletionBlock = nil
  }


  func reloadDataWithCompletion(completion: @escaping () -> Void) {
    reloadDataCompletionBlock = completion
    super.reloadData()
  }
}
