//
//  FindUsernameCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 07.02.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class FindUsernamesCall: ResponseArrayCall<MemberProtocol, APIMember> {
    public init(username: String, context: String?, id: String?) {
        var url = "members/find/\(username)"
        if let context = context, let id = id {
            url += "?context=\(context)&id=\(id)"
        }
        super.init(httpMethod: .GET, endpoint: url)
    }
}
