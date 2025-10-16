//
//  LookingForPartyCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 14.06.23.
//  Copyright © 2023 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class LookingForPartyCall: ResponseArrayCall<MemberProtocol, APIMember> {
    public init() {
        super.init(httpMethod: .GET, endpoint: "looking-for-party")
    }
}
