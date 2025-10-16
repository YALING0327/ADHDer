//
//  RunCronCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 29.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RunCronCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init() {
        super.init(httpMethod: .POST, endpoint: "cron")
    }
}
