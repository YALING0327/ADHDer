//
//  UpdateUsernameCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class UpdateUsernameCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(username: String, password: String? = nil) {
        var obj = ["username": username]
        if let password = password {
            obj["password"] = password
        }
        let json = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
        super.init(httpMethod: .PUT, endpoint: "user/auth/update-username", postData: json)
    }
}
