//
//  LeaveGroupCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 11.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class LeaveGroupCall: ResponseObjectCall<GroupProtocol, APIGroup> {
    public init(groupID: String, leaveChallenges: Bool) {
        var data = [String: String]()
        if leaveChallenges {
            data["keepChallenges"] = "leave-challenges"
        } else {
            data["keepChallenges"] = "remain-in-challenges"
        }
        let json = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/leave", postData: json)
    }
}
