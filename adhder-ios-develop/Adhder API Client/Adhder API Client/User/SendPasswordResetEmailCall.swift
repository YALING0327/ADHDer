//
//  SendPasswordResetEmailCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class SendPasswordResetEmailCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(email: String) {
        let json = try? JSONSerialization.data(withJSONObject: ["email": email ], options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "user/reset-password", postData: json, needsAuthentication: false)
    }
}
