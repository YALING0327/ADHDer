//
//  SleepCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class SleepCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init() {
        super.init(httpMethod: .POST, endpoint: "user/sleep")
    }
}
