//
//  File.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 12.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol HatchingPotionProtocol: ItemProtocol {
    var premium: Bool { get set }
    var limited: Bool { get set }
}

public extension HatchingPotionProtocol {
    var imageName: String {
        return "Pet_HatchingPotion_\(key ?? "")"
    }
}
