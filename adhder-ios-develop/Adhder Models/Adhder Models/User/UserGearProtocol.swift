//
//  UserGearProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 09.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol UserGearProtocol {
    var equipped: OutfitProtocol? { get set }
    var costume: OutfitProtocol? { get set }
    var owned: [OwnedGearProtocol] { get set }
}
