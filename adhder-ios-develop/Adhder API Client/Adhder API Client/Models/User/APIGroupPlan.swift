//
//  APIGroupPlan.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 29.08.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

public class APIGroupPlan: Decodable, GroupPlanProtocol {
    public var id: String?
    public var name: String?
    public var leaderID: String?
    public var summary: String?
}
