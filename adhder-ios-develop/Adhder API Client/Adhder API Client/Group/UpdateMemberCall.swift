//
//  UpdateMemberCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 12.12.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class UpdateMemberCall: ResponseObjectCall<MemberProtocol, APIMember> {
    public init(userID: String, updateDict: [String: Encodable]) {
        let json = try? JSONSerialization.data(withJSONObject: updateDict, options: .prettyPrinted)
        super.init(httpMethod: .PUT, endpoint: "hall/heroes/\(userID)", postData: json)
    }
}
