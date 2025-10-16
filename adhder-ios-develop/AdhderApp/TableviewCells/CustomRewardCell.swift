//
//  CustomRewrdCell.swift
//  Adhder
//
//  Created by Phillip on 21.08.17.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models
import Down

class CustomRewardCell: UICollectionViewCell {
    
    @IBOutlet weak var mainRewardWrapper: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var amountLabel: AbbreviatedNumberLabel!
    @IBOutlet weak var buyButton: UIView!

    var onBuyButtonTapped: (() -> Void)?
    
    public var canAfford: Bool = false {
        didSet {
            if canAfford {
                currencyImageView.alpha = 1.0
                buyButton.backgroundColor = UIColor.yellow500.withAlphaComponent(0.3)
                if ThemeService.shared.theme.isDark {
                    amountLabel.textColor = UIColor.yellow100
                } else {
                    amountLabel.textColor = UIColor.yellow1
                }
            } else {
                currencyImageView.alpha = 0.6
                buyButton.backgroundColor = ThemeService.shared.theme.offsetBackgroundColor.withAlphaComponent(0.5)
                amountLabel.textColor = ThemeService.shared.theme.dimmedTextColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyImageView.image = AdhderIcons.imageOfGold
        
        buyButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buyButtonTapped)))
    }
    
    func configure(reward: TaskProtocol) {
        let theme = ThemeService.shared.theme
        titleLabel.font = UIFontMetrics.default.scaledSystemFont(ofSize: 15)
        if let text = reward.text {
            titleLabel.attributedText = try? Down(markdownString: text.unicodeEmoji).toAdhderAttributedString(baseSize: 15, textColor: theme.primaryTextColor)
        } else {
            titleLabel.text = ""
        }
        notesLabel.font = UIFontMetrics.default.scaledSystemFont(ofSize: 11)
        if let trimmedNotes = reward.notes?.trimmingCharacters(in: .whitespacesAndNewlines), trimmedNotes.isEmpty == false {
            notesLabel.attributedText = try? Down(markdownString: trimmedNotes.unicodeEmoji).toAdhderAttributedString(baseSize: 11, textColor: theme.secondaryTextColor)
            notesLabel.isHidden = false
        } else {
            notesLabel.isHidden = true
        }
        amountLabel.text = String(reward.value)
        
        backgroundColor = theme.contentBackgroundColor
        mainRewardWrapper.backgroundColor = theme.windowBackgroundColor
        titleLabel.textColor = theme.primaryTextColor
        notesLabel.textColor = theme.ternaryTextColor
        notesLabel.numberOfLines = 0
    }
    
    @objc
    func buyButtonTapped() {
        if let action = onBuyButtonTapped {
            action()
        }
    }
}

extension CustomRewardCell: PathTraceable {
    func visiblePath() -> UIBezierPath {
        return UIBezierPath(roundedRect: mainRewardWrapper.frame, cornerRadius: mainRewardWrapper.cornerRadius)
    }
}
