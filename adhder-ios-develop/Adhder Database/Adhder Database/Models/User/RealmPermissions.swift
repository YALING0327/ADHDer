//
//  RealmPermissions.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 12.12.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import RealmSwift

class RealmPermissions: BaseModel, PermissionsProtocol {
    @objc dynamic var userID: String?
    dynamic var fullAccess: Bool = false
    dynamic var moderator: Bool = false
    dynamic var userSupport: Bool = false
    
    override static func primaryKey() -> String {
        return "userID"
    }
    
    convenience init(userID: String?, protocolObject: PermissionsProtocol) {
        self.init()
        self.userID = userID
        fullAccess = protocolObject.fullAccess
        moderator = protocolObject.moderator
        userSupport = protocolObject.userSupport
    }
}
