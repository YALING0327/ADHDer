//
//  SyncUserStatsCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 08.01.24.
//  Copyright © 2024 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class SyncUserStatsCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init() {
        super.init(httpMethod: .POST, endpoint: "user/stat-sync")
    }
}
