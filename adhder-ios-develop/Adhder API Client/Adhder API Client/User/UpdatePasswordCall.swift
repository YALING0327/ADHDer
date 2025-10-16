//
//  UpdatePasswordCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class UpdatePasswordCall: ResponseObjectCall<LoginResponseProtocol, APILoginResponse> {
    public init(newPassword: String, oldPassword: String, confirmPassword: String) {
        let json = try? JSONSerialization.data(withJSONObject: ["newPassword": newPassword, "password": oldPassword, "confirmPassword": confirmPassword], options: .prettyPrinted)
        super.init(httpMethod: .PUT, endpoint: "user/auth/update-password", postData: json)
    }
}
