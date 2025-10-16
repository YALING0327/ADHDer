//
//  EquipmentCell.swift
//  Adhder
//
//  Created by Phillip Thelen on 19.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

class EquipmentCell: UITableViewCell {
    
    @IBOutlet weak var gearImageView: NetworkImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var twoHandedView: UIView!
    @IBOutlet weak var twoHandedIconView: UIImageView!
    @IBOutlet weak var twoHandedLabel: UILabel!
    
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var constitutionLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var perceptionLabel: UILabel!
    @IBOutlet weak var noBenefitsLabel: UILabel!
    
    var isEquipped: Bool = false {
        didSet {
            if isEquipped {
                backgroundColor = ThemeService.shared.theme.tintColor.withAlphaComponent(0.1)
                gearImageView.backgroundColor = ThemeService.shared.theme.contentBackgroundColor
            } else {
                backgroundColor = ThemeService.shared.theme.contentBackgroundColor
                gearImageView.backgroundColor = ThemeService.shared.theme.windowBackgroundColor

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        twoHandedIconView.image = AdhderIcons.imageOfTwoHandedIcon
        twoHandedLabel.text = L10n.twoHanded
        noBenefitsLabel.text = L10n.noBenefit
        gearImageView.cornerRadius = 26
    }
    
    func configure(_ gear: GearProtocol) {
        gearImageView.setImagewith(name: "shop_\(gear.key ?? "")")
        titleLabel.text = gear.text
        descriptionlabel.text = gear.notes
        
        if gear.twoHanded {
            twoHandedView.isHidden = false
        } else {
            twoHandedView.isHidden = true
        }
        
        strengthLabel.isHidden = true
        constitutionLabel.isHidden = true
        intelligenceLabel.isHidden = true
        perceptionLabel.isHidden = true
        noBenefitsLabel.isHidden = true
        
        var hasBenefits = false
        if gear.strength > 0 {
            strengthLabel.isHidden = false
            strengthLabel.attributedText = attributedLabel(title: "STR: ", value: "+\(gear.strength)")
            hasBenefits = true
        }
        if gear.constitution > 0 {
            constitutionLabel.isHidden = false
            constitutionLabel.attributedText = attributedLabel(title: "CON: ", value: "+\(gear.constitution)")
            hasBenefits = true
        }
        if gear.intelligence > 0 {
            intelligenceLabel.isHidden = false
            intelligenceLabel.attributedText = attributedLabel(title: "INT: ", value: "+\(gear.intelligence)")
            hasBenefits = true
        }
        if gear.perception > 0 {
            perceptionLabel.isHidden = false
            perceptionLabel.attributedText = attributedLabel(title: "PER: ", value: "+\(gear.perception)")
            hasBenefits = true
        }
        if !hasBenefits {
            noBenefitsLabel.isHidden = false
        }
    }
    
    private func attributedLabel(title: String, value: String) -> NSAttributedString {
        let titleString = NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.gray200])
        return titleString + NSAttributedString(string: value, attributes: [.foregroundColor: UIColor.green50])
    }
}
