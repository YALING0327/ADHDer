//
//  RegisterPushDeviceCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 28.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RegisterPushDeviceCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(regID: String) {
        let json = try? JSONSerialization.data(withJSONObject: ["regId": regID, "type": "ios"], options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "user/push-devices", postData: json)
    }
}
