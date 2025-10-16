//
//  JoinGroupCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 11.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class JoinGroupCall: ResponseObjectCall<GroupProtocol, APIGroup> {
    public init(groupID: String) {
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/join", postData: nil)
    }
}
