//
//  RealmProfile.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 09.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Adhder_Models

@objc
class RealmProfile: Object, ProfileProtocol {
    @objc dynamic var name: String?
    @objc dynamic var blurb: String?
    @objc dynamic var photoUrl: String?
    
    @objc dynamic var id: String?
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(id: String?, profile: ProfileProtocol) {
        self.init()
        self.id = id
        name = profile.name
        blurb = profile.blurb
        photoUrl = profile.photoUrl
    }
}
