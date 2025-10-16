//
//  RetrieveWorldStateCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveWorldStateCall: ResponseObjectCall<WorldStateProtocol, APIWorldState> {
    public init() {
        super.init(httpMethod: .GET, endpoint: "world-state", needsAuthentication: false)
    }
}
