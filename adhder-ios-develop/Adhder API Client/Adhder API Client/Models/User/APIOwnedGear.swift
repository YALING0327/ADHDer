//
//  APIOwnedGear.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 12.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIOwnedGear: OwnedGearProtocol, Codable {
    
    var key: String?
    var isOwned: Bool
    
    init(key: String, isOwned: Bool) {
        self.key = key
        self.isOwned = isOwned
    }
}
