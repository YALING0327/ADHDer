//
//  SocialLoginCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class SocialLoginCall: ResponseObjectCall<LoginResponseProtocol, APILoginResponse> {
    public init(userID: String, network: String, accessToken: String, allowRegister: Bool) {
        let json = try? JSONSerialization.data(withJSONObject: ["network": network, "authResponse": [
            "access_token": accessToken,
            "client_id": userID
            ],
            "allowRegister": allowRegister], options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "user/auth/social", postData: json, errorHandler: PrintNetworkErrorHandler(), needsAuthentication: false)
    }
}
