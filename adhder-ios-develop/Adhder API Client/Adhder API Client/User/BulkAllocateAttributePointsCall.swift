//
//  BullkAllocateAttributePoints.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class BulkAllocateAttributePointsCall: ResponseObjectCall<StatsProtocol, APIStats> {
    public init(strength: Int, intelligence: Int, constitution: Int, perception: Int) {
        let updateDict = ["stats": [
            "str": strength,
            "int": intelligence,
            "con": constitution,
            "per": perception
            ]
        ]
        let json = try? JSONSerialization.data(withJSONObject: updateDict, options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "user/allocate-bulk", postData: json)
    }
}
