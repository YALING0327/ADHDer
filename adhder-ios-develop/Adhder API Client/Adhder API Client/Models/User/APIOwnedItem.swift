//
//  APIOwnedItem.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 28.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIOwnedItem: OwnedItemProtocol, Codable {
    
    var key: String?
    var numberOwned: Int
    var itemType: String?
    
    init(key: String, numberOwned: Int, itemType: String) {
        self.key = key
        self.numberOwned = numberOwned
        self.itemType = itemType
    }
}
