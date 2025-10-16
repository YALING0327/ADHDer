//
//  RetrieveChallengesCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 24.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveChallengesCall: ResponseArrayCall<ChallengeProtocol, APIChallenge> {
    public init(page: Int, memberOnly: Bool) {
        var url = "challenges/user?page=\(page)"
        if memberOnly {
            url += "&member=true"
        }
        super.init(httpMethod: .GET, endpoint: url)
    }
}
