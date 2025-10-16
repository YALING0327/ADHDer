//
//  UpdateDayStartTimeCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 31.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class UpdateDayStartTimeCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init(_ time: Int) {
        let json = try? JSONSerialization.data(withJSONObject: ["dayStart": time], options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "user/custom-day-start", postData: json)
    }
}
