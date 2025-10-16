//
//  DeleteTaskCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 27.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

public class DeleteTaskCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(task: TaskProtocol) {
        super.init(httpMethod: .DELETE, endpoint: "tasks/\(task.id ?? "")")
    }
}
