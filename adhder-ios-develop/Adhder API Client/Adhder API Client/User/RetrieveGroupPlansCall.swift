//
//  RetrieveGroupPlansCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 29.08.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveGroupPlansCall: ResponseArrayCall<GroupPlanProtocol, APIGroupPlan> {
    public init() {
        super.init(httpMethod: .GET, endpoint: "group-plans")
    }
}
