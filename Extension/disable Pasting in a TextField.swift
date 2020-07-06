https://stackoverflow.com/questions/29596043/how-to-disable-pasting-in-a-textfield-in-swift/39015132

import UIKit

class NMTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

import UIKit

// MARK: Enable/Disable textfield longpress actions

enum ResponderStandardEditActions {
    case cut, copy, paste, select, selectAll, delete
    case makeTextWritingDirectionLeftToRight, makeTextWritingDirectionRightToLeft
    case toggleBoldface, toggleItalics, toggleUnderline
    case increaseSize, decreaseSize

    var selector: Selector {
        switch self {
            case .cut:
                return #selector(UIResponderStandardEditActions.cut)
            case .copy:
                return #selector(UIResponderStandardEditActions.copy)
            case .paste:
                return #selector(UIResponderStandardEditActions.paste)
            case .select:
                return #selector(UIResponderStandardEditActions.select)
            case .selectAll:
                return #selector(UIResponderStandardEditActions.selectAll)
            case .delete:
                return #selector(UIResponderStandardEditActions.delete)
            case .makeTextWritingDirectionLeftToRight:
                return #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight)
            case .makeTextWritingDirectionRightToLeft:
                return #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft)
            case .toggleBoldface:
                return #selector(UIResponderStandardEditActions.toggleBoldface)
            case .toggleItalics:
                return #selector(UIResponderStandardEditActions.toggleItalics)
            case .toggleUnderline:
                return #selector(UIResponderStandardEditActions.toggleUnderline)
            case .increaseSize:
                return #selector(UIResponderStandardEditActions.increaseSize)
            case .decreaseSize:
                return #selector(UIResponderStandardEditActions.decreaseSize)
        }
    }
}

class TextField: UITextField {

    private var editActions: [ResponderStandardEditActions: Bool]?
    private var filterEditActions: [ResponderStandardEditActions: Bool]?

    func setEditActions(only actions: [ResponderStandardEditActions]) {
        if self.editActions == nil { self.editActions = [:] }
        filterEditActions = nil
        actions.forEach { self.editActions?[$0] = true }
    }

    func addToCurrentEditActions(actions: [ResponderStandardEditActions]) {
        if self.filterEditActions == nil { self.filterEditActions = [:] }
        editActions = nil
        actions.forEach { self.filterEditActions?[$0] = true }
    }

    private func filterEditActions(actions: [ResponderStandardEditActions], allowed: Bool) {
        if self.filterEditActions == nil { self.filterEditActions = [:] }
        editActions = nil
        actions.forEach { self.filterEditActions?[$0] = allowed }
    }

    func filterEditActions(notAllowed: [ResponderStandardEditActions]) {
        filterEditActions(actions: notAllowed, allowed: false)
    }

    func resetEditActions() { editActions = nil }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let actions = editActions {
            for _action in actions where _action.key.selector == action { return _action.value }
            return false
        }

        if let actions = filterEditActions {
            for _action in actions where _action.key.selector == action { return _action.value }
        }

        return super.canPerformAction(action, withSender: sender)
    }
}

let textField = TextField(frame: CGRect(x: 50, y: 50, width: 200, height: 50))
textField.borderStyle = .roundedRect
view.addSubview(textField)
textField.setEditActions(only: [.copy, .cut, .paste])
//textField.filterEditActions(notAllowed: [.copy, .cut, .paste])
//textField.addToCurrentEditActions(actions: [.paste])
