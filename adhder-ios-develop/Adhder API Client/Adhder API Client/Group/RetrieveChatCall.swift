//
//  RetrieveChatCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 30.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveChatCall: ResponseArrayCall<ChatMessageProtocol, APIChatMessage> {
    public init(groupID: String) {
        super.init(httpMethod: .GET, endpoint: "groups/\(groupID)/chat")
    }
}
