//
//  RetrieveMemberUsernameCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 10.12.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveMemberUsernameCall: ResponseObjectCall<MemberProtocol, APIMember> {
    public init(username: String) {
        super.init(httpMethod: .GET, endpoint: "members/username/\(username)")
    }
}
