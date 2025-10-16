//
//  RealmAssignedDetails.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 28.10.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Adhder_Models

class RealmAssignedDetails: BaseModel, AssignedDetailsProtocol {
    @objc dynamic var combinedID: String?
    @objc dynamic var assignedUserID: String?
    @objc dynamic var assignedDate: Date?
    @objc dynamic var assignedUsername: String?
    @objc dynamic var assigningUsername: String?
    @objc dynamic var completed: Bool = false
    
    override static func primaryKey() -> String {
        return "combinedID"
    }

    convenience init(taskID: String?, objectProtocol: AssignedDetailsProtocol) {
        self.init()
        combinedID = (objectProtocol.assignedUserID ?? "") + (taskID ?? "")
        assignedUserID = objectProtocol.assignedUserID
        assignedDate = objectProtocol.assignedDate
        assignedUsername = objectProtocol.assignedUsername
        assigningUsername = objectProtocol.assigningUsername
        completed = objectProtocol.completed
    }
}
