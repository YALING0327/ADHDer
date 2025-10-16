//
//  CancelSubscribeCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 04.11.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class CancelSubscribeCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init() {
        super.init(httpMethod: .GET, endpoint: "iap/ios/subscribe/cancel")
        customErrorHandler = PrintNetworkErrorHandler()
    }
}
