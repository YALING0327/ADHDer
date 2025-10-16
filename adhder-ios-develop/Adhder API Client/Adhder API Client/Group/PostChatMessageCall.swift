//
//  PostChatMessageCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 30.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class PostChatMessageCall: ResponseObjectCall<ChatMessageProtocol, APIChatMessage> {
    public init(groupID: String, chatMessage: String) {
        let updateDict = [
            "message": chatMessage
        ]
        let json = try? JSONSerialization.data(withJSONObject: updateDict, options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/chat", postData: json)
    }
}
