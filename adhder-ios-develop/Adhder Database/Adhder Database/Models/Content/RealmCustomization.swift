//
//  RealmCustomization.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 20.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import RealmSwift

class RealmCustomization: BaseModel, CustomizationProtocol {
    @objc dynamic var combinedKey: String?
    @objc dynamic var key: String?
    @objc dynamic var type: String?
    @objc dynamic var text: String?
    @objc dynamic var notes: String?
    @objc dynamic var group: String?
    @objc dynamic var price: Float = 0
    var set: CustomizationSetProtocol? {
        get {
            return realmSet
        }
        set {
            if let newSet = newValue as? RealmCustomizationSet {
                realmSet = newSet
            } else if let newSet = newValue {
                realmSet = RealmCustomizationSet(newSet)
            }
        }
    }
    @objc dynamic var realmSet: RealmCustomizationSet?
    
    override static func primaryKey() -> String {
        return "combinedKey"
    }

    convenience init(_ customizationProtocol: CustomizationProtocol) {
        self.init()
        key = customizationProtocol.key
        type = customizationProtocol.type
        text = customizationProtocol.text
        notes = customizationProtocol.notes
        group = customizationProtocol.group
        combinedKey = (key ?? "") + (type ?? "") + (group ?? "")
        price = customizationProtocol.price
        set = customizationProtocol.set
    }
}
