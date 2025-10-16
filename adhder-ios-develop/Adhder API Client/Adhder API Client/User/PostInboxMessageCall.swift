//
//  PostInboxMessageCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 25.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class PostInboxMessageCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(userID: String, inboxMessage: String) {
        let updateDict = [
            "message": inboxMessage,
            "toUserId": userID
        ]
        let json = try? JSONSerialization.data(withJSONObject: updateDict, options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "members/send-private-message", postData: json)
    }
}
