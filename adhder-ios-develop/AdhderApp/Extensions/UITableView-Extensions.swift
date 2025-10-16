//
//  UITableView-Extensions.swift
//  Adhder
//
//  Created by Phillip Thelen on 20.08.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import UIKit

extension UITableView {
    func isVisible(indexPath: IndexPath) -> Bool {
        return indexPathsForVisibleRows?.contains(where: { visiblePath -> Bool in
            return visiblePath.section == indexPath.section && visiblePath.item == indexPath.item
        }) == true
    }
    
    func isVisible(cell: UITableViewCell) -> Bool {
        return visibleCells.contains(cell)
    }
}
