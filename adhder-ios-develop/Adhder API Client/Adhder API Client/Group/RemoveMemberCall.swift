//
//  TransferOwnershipCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 16.09.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RemoveMemberCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(groupID: String, userID: String) {
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/removeMember/\(userID)")
    }
}
