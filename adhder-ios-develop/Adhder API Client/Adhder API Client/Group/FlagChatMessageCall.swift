//
//  FlagChatMessageCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 30.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class FlagChatMessageCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(groupID: String, chatMessage: ChatMessageProtocol, data: [String: Any]) {
        let json = try? JSONSerialization.data(withJSONObject: data)
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/chat/\(chatMessage.id ?? "")/flag", postData: json)
    }
}
