//
//  RealmChallengeCategory.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 24.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import RealmSwift

class RealmChallengeCategory: Object, ChallengeCategoryProtocol {
    var id: String?
    var slug: String?
    var name: String?
    
    override static func primaryKey() -> String {
        return "id"
    }

    convenience init(_ protocolObject: ChallengeCategoryProtocol) {
        self.init()
        id = protocolObject.id
        slug = protocolObject.slug
        name = protocolObject.name
    }
}
