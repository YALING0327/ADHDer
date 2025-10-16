//
//  APIOwnedMount.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIOwnedMount: OwnedMountProtocol, Decodable {
    var key: String?
    var owned: Bool
    
    init(key: String?, owned: Bool) {
        self.key = key
        self.owned = owned
    }
}
