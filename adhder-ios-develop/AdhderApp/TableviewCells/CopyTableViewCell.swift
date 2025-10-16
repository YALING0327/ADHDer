//
//  CopyTableViewCell.swift
//  Adhder
//
//  Created by Phillip Thelen on 07.03.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import UIKit

class CopyTableViewCell: UITableViewCell {
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = detailTextLabel?.text
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    func selectedCell() {
        if let view = superview {
            becomeFirstResponder()
            let menu = UIMenuController.shared
            menu.showMenu(from: view, rect: frame)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
