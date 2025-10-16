//
//  OwnedPetProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol OwnedPetProtocol {
    var key: String? { get set }
    var trained: Int { get set }
}

public extension OwnedPetProtocol {
    var isOwned: Bool {
        return trained > 0
    }
}
