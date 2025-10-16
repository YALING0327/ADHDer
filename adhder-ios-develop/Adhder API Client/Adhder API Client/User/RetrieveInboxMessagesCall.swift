//
//  RetrieveInboxMessagesCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 28.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveInboxMessagesCall: ResponseArrayCall<InboxMessageProtocol, APIInboxMessage> {
    public init(uuid: String, page: Int) {
        super.init(httpMethod: .GET, endpoint: "inbox/messages?conversation=\(uuid)&page=\(page)")
    }
}
