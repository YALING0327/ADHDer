//
//  RetrieveInboxConversationsCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 11.09.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveInboxConversationsCall: ResponseArrayCall<InboxConversationProtocol, APIInboxConversation> {
    public init() {
        super.init(httpMethod: .GET, endpoint: "inbox/conversations")
    }
}
