//
//  RetrieveHallOfContributors.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 11.08.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveHallOfContributorsCall: ResponseArrayCall<MemberProtocol, APIMember> {
    public init() {
        super.init(httpMethod: .GET, endpoint: "hall/heroes", needsAuthentication: false, ignoreEtag: true)
    }
}
