//
//  DeleteChatMessageCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 30.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class DeleteChatMessageCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(groupID: String, chatMessage: ChatMessageProtocol) {
        super.init(httpMethod: .DELETE, endpoint: "groups/\(groupID)/chat/\(chatMessage.id ?? "")")
    }
}
