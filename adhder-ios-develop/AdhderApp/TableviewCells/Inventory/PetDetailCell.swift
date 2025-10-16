//
//  PetDetailCell.swift
//  Adhder
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

class PetDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: NetworkImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activeIndicator: UIImageView!
    
    func configure(petItem: PetStableItem, currentPet: String?) {
        backgroundColor = ThemeService.shared.theme.contentBackgroundColor
        bgView.backgroundColor = ThemeService.shared.theme.windowBackgroundColor
        let percentage = Float(petItem.trained) / 50.0
        if let key = petItem.pet?.key {
            if petItem.trained != 0 {
                imageView.setImagewith(name: "stable_Pet-\(key)")
                if petItem.trained > 0 && petItem.canRaise {
                    accessibilityLabel = L10n.petAccessibilityLabelRaised(petItem.pet?.text ?? "", Int(percentage*100))
                } else if !petItem.canRaise {
                    accessibilityLabel = L10n.petAccessibilityLabelMountOwned(petItem.pet?.text ?? "")
                } else {
                    accessibilityLabel = L10n.petAccessibilityLabelMountOwned(petItem.pet?.text ?? "")
                }
            } else {
                imageView.setImagewith(name: "stable_Pet-\(key)-outline")
                accessibilityLabel = L10n.Accessibility.unknownPet
            }
        }
        if petItem.trained == -1 {
            imageView.alpha = 0.3
        } else if ThemeService.shared.isDarkTheme == true && petItem.trained == 0 {
            imageView.alpha = 0.5
        } else {
            imageView.alpha = 1.0
        }
        progressView.tintColor = ThemeService.shared.theme.successColor
        progressView.trackTintColor = ThemeService.shared.theme.offsetBackgroundColor
        if petItem.pet?.type != " " && petItem.trained > 0 && petItem.canRaise == true {
            progressView.isHidden = false
            progressView.progress = percentage
        } else {
            progressView.isHidden = true
        }
        
        activeIndicator.isHidden = currentPet != petItem.pet?.key
        activeIndicator.backgroundColor = .teal100
        
        shouldGroupAccessibilityChildren = true
        isAccessibilityElement = true
    }
}
