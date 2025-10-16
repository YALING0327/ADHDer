//
//  RetrieveMemberCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 11.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveMemberCall: ResponseObjectCall<MemberProtocol, APIMember> {
    public init(userID: String, fromHall: Bool = false) {
        if fromHall {
            super.init(httpMethod: .GET, endpoint: "hall/heroes/\(userID)")
        } else {
            if UUID(uuidString: userID) != nil {
                super.init(httpMethod: .GET, endpoint: "members/\(userID)")
            } else {
                super.init(httpMethod: .GET, endpoint: "members/username/\(userID)")
            }
        }
    }
}
