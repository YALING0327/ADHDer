//
//  RetrieveGroupCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 29.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveGroupCall: ResponseObjectCall<GroupProtocol, APIGroup> {
    public init(groupID: String) {
        super.init(httpMethod: .GET, endpoint: "groups/\(groupID)")
    }
}
