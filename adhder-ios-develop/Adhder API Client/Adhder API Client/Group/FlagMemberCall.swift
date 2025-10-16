//
//  FlagMemberCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 24.11.23.
//  Copyright © 2023 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class FlagMemberCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(memberID: String, data: [String: Any]) {
        let json = try? JSONSerialization.data(withJSONObject: data)
        super.init(httpMethod: .POST, endpoint: "members/\(memberID)/flag", postData: json)
    }
}
