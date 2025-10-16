//
//  CustomizationProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 20.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol CustomizationProtocol: BaseModelProtocol {
    var key: String? { get set }
    var type: String? { get set }
    var text: String? { get set }
    var notes: String? { get set }
    var group: String? { get set }
    var price: Float { get set }
    var set: CustomizationSetProtocol? { get set }
}

public extension CustomizationProtocol {
    
    func imageName(forUserPreferences preferences: PreferencesProtocol?) -> String? {
        guard let key = key else {
            return nil
        }
        switch type {
        case "shirt":
            return "\(preferences?.size ?? "slim")_shirt_\(key)"
        case "skin":
            return "skin_\(key)"
        case "background":
            return "icon_background_\(key)"
        case "chair":
            return "chair_\(key)"
        case "hair":
            return hairImageName(forUserPreferences: preferences)
        default:
            return nil
        }
    }
    
    private func hairImageName(forUserPreferences preferences: PreferencesProtocol?) -> String? {
        guard let key = key else {
            return nil
        }
        let hairColor = preferences?.hair?.color ?? ""
        switch group {
        case "bangs":
            return "hair_bangs_\(key)_\(hairColor)"
        case "base":
            return "hair_base_\(key)_\(hairColor)"
        case "mustache":
            return "hair_mustache_\(key)_\(hairColor)"
        case "beard":
            return "hair_beard_\(key)_\(hairColor)"
        case "color":
            let bangs = preferences?.hair?.bangs ?? 1
            return "hair_bangs_\(bangs > 0 ? bangs : 1)_\(key)"
        case "flower":
            return "hair_flower_\(key)"
        default:
            return nil
        }
    }
    
    func iconName(forUserPreferences preferences: PreferencesProtocol?) -> String? {
        let imagename = imageName(forUserPreferences: preferences)
        if let name = imagename {
            if name == "chair_none" {
                return "head_0"
            }
            if !name.starts(with: "icon_") {
                return "icon_\(name)"
            } else {
                return name
            }
        } else {
            return nil
        }
    }
    
    var isPurchasable: Bool {
        return price > 0 && (set?.isPurchasable ?? true) && (set?.key?.contains("incentive") != true)
    }
    
    var path: String {
        if let group = group {
            return "\(type ?? "").\(group).\(key ?? "")"
        } else {
            return "\(type ?? "").\(key ?? "")"
        }
    }
    
    var userPath: String {
        switch type {
        case "shirt":
            return "preferences.shirt"
        case "skin":
            return "preferences.skin"
        case "background":
            return "preferences.background"
        case "chair":
            return "preferences.chair"
        case "hair":
            switch group {
            case "bangs":
                return "preferences.hair.bangs"
            case "base":
                return "preferences.hair.base"
            case "mustache":
                return "preferences.hair.mustache"
            case "beard":
                return "preferences.hair.beard"
            case "color":
                return "preferences.hair.color"
            case "flower":
                return "preferences.hair.flower"
            default:
                return ""
            }
        default:
            return ""
        }
    }
}
