//
//  StableOverviewCell.swift
//  Adhder
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit

class StableOverviewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: NetworkImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activeIndicator: UIImageView!
    
    func configure(item: StableOverviewItem, ownsItem: Bool, currentSelected: String?) {
        backgroundColor = ThemeService.shared.theme.contentBackgroundColor
        bgView.backgroundColor = ThemeService.shared.theme.windowBackgroundColor
        textLabel.text = item.text
        countLabel.text = "\(item.numberOwned)/\(item.totalNumber)"
        
        countLabel.backgroundColor = ThemeService.shared.theme.offsetBackgroundColor
        textLabel.textColor = ThemeService.shared.theme.secondaryTextColor
        imageView.alpha = 1.0
        imageView.tintColor = ThemeService.shared.theme.dimmedColor
        if item.numberOwned == 0 && !ownsItem {
            countLabel.textColor = ThemeService.shared.theme.dimmedTextColor
            textLabel.textColor = ThemeService.shared.theme.dimmedTextColor
            imageView.alpha = 0.5
        } else if item.numberOwned == item.totalNumber {
            countLabel.backgroundColor = ThemeService.shared.theme.successColor
            countLabel.textColor = .white
        } else {
            countLabel.textColor = ThemeService.shared.theme.secondaryTextColor
        }
        if item.type == "special" || item.type == "wacky" {
            textLabel?.numberOfLines = 2
            countLabel?.isHidden = true
            countLabelHeightConstraint.constant = 0
            if item.numberOwned != 0 {
                imageView.setImagewith(name: item.imageName)
            } else {
                imageView.setImagewith(name: "\(item.imageName)-outline")
            }
        } else {
            textLabel?.numberOfLines = 1
            countLabel?.isHidden = false
            countLabelHeightConstraint.constant = 20
            imageView.setImagewith(name: item.imageName)
        }
        
        activeIndicator.isHidden = currentSelected != item.searchKey
        activeIndicator.backgroundColor = .teal100
        
        shouldGroupAccessibilityChildren = true
        isAccessibilityElement = true
        accessibilityLabel = item.text + " " + L10n.Accessibility.xofx(item.numberOwned, item.totalNumber)
    }
    
}
