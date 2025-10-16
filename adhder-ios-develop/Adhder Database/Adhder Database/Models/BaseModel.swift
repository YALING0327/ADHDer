//
//  BaseModel.swift
//  Adhder Database
//
//  Created by Phillip Thelen on 02.12.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Adhder_Models

class BaseModel: Object, BaseModelProtocol {
    @objc dynamic var modelID: String?

    var isValid: Bool {
        return !isInvalidated
    }
    
    var isManaged: Bool {
        return realm != nil
    }
}
