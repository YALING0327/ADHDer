//
//  VerifyUsernameCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.10.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class CheckEmailCall: ResponseObjectCall<CheckEmailResponse, APICheckEmailResponse> {
    public init(email: String) {
        let obj = ["email": email]
        let json = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "user/auth/check-email", postData: json, needsAuthentication: false)
    }
}
