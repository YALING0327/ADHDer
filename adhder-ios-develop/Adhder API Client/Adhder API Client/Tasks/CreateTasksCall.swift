//
//  CreateTasksCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

public class CreateTasksCall: ResponseArrayCall<TaskProtocol, APITask> {
    public init(tasks: [TaskProtocol]) {
        let encoder = JSONEncoder()
        encoder.setAdhderDateEncodingStrategy()
        let json = try? encoder.encode(tasks.map({ (task) in
            return APITask(task)
        }))
        super.init(httpMethod: .POST, endpoint: "tasks/user", postData: json)
    }
}
