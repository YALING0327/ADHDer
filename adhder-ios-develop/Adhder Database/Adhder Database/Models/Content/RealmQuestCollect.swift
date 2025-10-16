//
//  RealmQuestCollect.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 13.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import RealmSwift

class RealmQuestCollect: Object, QuestCollectProtocol {
    @objc dynamic var key: String?
    @objc dynamic var text: String?
    @objc dynamic var count: Int = 0
    
    override static func primaryKey() -> String {
        return "key"
    }
    
    convenience init(_ questCollect: QuestCollectProtocol) {
        self.init()
        key = questCollect.key
        text = questCollect.text
        count = questCollect.count
    }
}
