//
//  EquipGearCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class EquipCall: ResponseObjectCall<UserItemsProtocol, APIUserItems> {
    public init(type: String, itemKey: String) {
        super.init(httpMethod: .POST, endpoint: "user/equip/\(type)/\(itemKey)", postData: nil)
    }
}
