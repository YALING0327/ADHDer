//
//  Currency.swift
//  Adhder
//
//  Created by Phillip on 24.08.17.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//

import UIKit

public enum Currency: String {
    
    case gold = "gold"
    case gem = "gems"
    case hourglass = "hourglasses"
    
    func getImage() -> UIImage {
        switch self {
        case .gold:
            return AdhderIcons.imageOfGold
        case .gem:
            return AdhderIcons.imageOfGem
        case .hourglass:
            return AdhderIcons.imageOfHourglass
        }
    }
    
    func getTextColor() -> UIColor {
        if ThemeService.shared.theme.isDark {
            switch self {
            case .gold:
                return .yellow100
            case .gem:
                return .green50
            case .hourglass:
                return .blue50
            }
        } else {
            switch self {
            case .gold:
                return .yellow1
            case .gem:
                return .green10
            case .hourglass:
                return .blue10
            }
        }
    }
}
