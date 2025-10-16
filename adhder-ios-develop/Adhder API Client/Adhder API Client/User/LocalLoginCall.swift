//
//  LocalLoginCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class LocalLoginCall: ResponseObjectCall<LoginResponseProtocol, APILoginResponse> {
    public init(username: String, password: String) {
        let json = try? JSONSerialization.data(withJSONObject: ["username": username, "password": password], options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "user/auth/local/login", postData: json, needsAuthentication: false)
    }
}
