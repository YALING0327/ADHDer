//
//  SpecialItemProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 08.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol SpecialItemProtocol: ItemProtocol {
    var target: String? { get set }
    var immediateUse: Bool { get set }
    var silent: Bool { get set }
}

public extension SpecialItemProtocol {
    var imageName: String {
        return "\(key ?? "")"
    }
}
