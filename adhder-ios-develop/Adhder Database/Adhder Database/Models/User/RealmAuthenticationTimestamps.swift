//
//  RealmAuthenticationTimestamps.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Adhder_Models

class RealmAuthenticationTimestamps: Object, AuthenticationTimestampsProtocol {
    @objc dynamic var createdAt: Date?
    @objc dynamic var loggedIn: Date?
    
    @objc dynamic var id: String?
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(userID: String?, protocolObject: AuthenticationTimestampsProtocol) {
        self.init()
        self.id = userID
        createdAt = protocolObject.createdAt
        loggedIn = protocolObject.loggedIn
    }
}
