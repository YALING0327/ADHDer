//
//  InviteToGroupCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 20.07.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class InviteToGroupCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(groupID: String, members: [String: Any]) {
        let json = try? JSONSerialization.data(withJSONObject: members, options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/invite", postData: json)
    }
}
