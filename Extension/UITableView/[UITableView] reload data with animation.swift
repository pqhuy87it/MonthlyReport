https://stackoverflow.com/questions/14576921/uitableview-reloaddata-with-animation/38378649
extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}

// delay and move cell
https://www.vadimbulavin.com/tableviewcell-display-animation/

static func makeMoveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
    return { cell, indexPath, _ in
        cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
        cell.alpha = 0

        UIView.animate(
            withDuration: duration,
            delay: delayFactor * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
        })
    }
}

let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
let animator = Animator(animation: animation)
animator.animate(cell: cell, at: indexPath, in: tableView)

// fade in-out
https://stackoverflow.com/questions/40314277/how-to-fade-in-out-the-background-color-of-a-tableviewcell-with-swift
let oldColor = cell.viewCell.backgroundColor
    UIView.animate(withDuration: 0.5, animations: {
        cell.viewCell.backgroundColor = UIColor.red
        }, completion: { _ in
            UIView.animate(withDuration: 0.5) {
                cell.viewCell.backgroundColor = oldColor
            }
    })

// animation with CATransition
https://stackoverflow.com/questions/419472/have-a-reloaddata-for-a-uitableview-animate-when-changing
let transition = CATransition()
transition.type = kCATransitionPush
transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
transition.fillMode = kCAFillModeForwards
transition.duration = 0.5
transition.subtype = kCATransitionFromTop
self.tableView.layer.addAnimation(transition, forKey: "UITableViewReloadDataAnimationKey")
// Update your data source here
self.tableView.reloadData()
