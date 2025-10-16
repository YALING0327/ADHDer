//
//  GroupPlanProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 29.08.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol GroupPlanProtocol {
    var id: String? { get set }
    var name: String? { get set }
    var leaderID: String? { get set }
    var summary: String? { get set }
}
