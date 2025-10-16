//
//  UnlinkAllTasksCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 10.08.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class UnlinkAllTasksCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(challengeID: String, keepOption: String) {
        super.init(httpMethod: .POST, endpoint: "tasks/unlink-all/\(challengeID)?keep=\(keepOption)")
    }
}
