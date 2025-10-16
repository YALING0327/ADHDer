//
//  RetrieveInAppRewardsCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 17.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveInAppRewardsCall: ResponseArrayCall<InAppRewardProtocol, APIInAppReward> {
    public init(language: String? = nil) {
        let url = language != nil ? "user/in-app-rewards?language=\(language ?? "")" : "user/in-app-rewards"
        super.init(httpMethod: .GET, endpoint: url)
    }
}
