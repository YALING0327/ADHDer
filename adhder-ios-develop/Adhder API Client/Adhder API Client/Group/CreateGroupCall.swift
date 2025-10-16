//
//  CreateGroupCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 10.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

public class CreateGroupCall: ResponseObjectCall<GroupProtocol, APIGroup> {
    public init(group: GroupProtocol) {
        let encoder = JSONEncoder()
        encoder.setAdhderDateEncodingStrategy()
        let json = try? encoder.encode(APIGroup(group))
        super.init(httpMethod: .POST, endpoint: "groups", postData: json)
    }
}
