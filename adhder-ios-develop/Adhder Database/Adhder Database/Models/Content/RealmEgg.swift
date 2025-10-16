//
//  RealmEgg.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 13.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import RealmSwift

class RealmEgg: RealmItem, EggProtocol {
    @objc dynamic var adjective: String?
    @objc dynamic var mountText: String?
    
    convenience init(_ egg: EggProtocol) {
        self.init(item: egg)
        adjective = egg.adjective
        mountText = egg.mountText
        itemType = ItemType.eggs.rawValue
    }
    
}
