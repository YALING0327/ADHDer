//
//  RetrieveChallengeCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 24.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveChallengeCall: ResponseObjectCall<ChallengeProtocol, APIChallenge> {
    public init(challengeID: String) {
        super.init(httpMethod: .GET, endpoint: "challenges/\(challengeID)")
    }
}
