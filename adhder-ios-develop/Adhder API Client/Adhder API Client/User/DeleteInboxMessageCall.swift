//
//  DeleteInboxMessageCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 25.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class DeleteInboxMessageCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(message: InboxMessageProtocol) {
        super.init(httpMethod: .DELETE, endpoint: "user/messages/\(message.id ?? "")")
    }
}
