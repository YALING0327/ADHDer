//
//  APIOwnedCustomization.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 23.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIOwnedCustomization: OwnedCustomizationProtocol, Decodable {
    var key: String?
    var type: String?
    var group: String?
    var isOwned: Bool
    
    init(key: String, type: String, group: String?, isOwned: Bool) {
        self.key = key
        self.type = type
        self.group = group
        self.isOwned = isOwned
    }
}
