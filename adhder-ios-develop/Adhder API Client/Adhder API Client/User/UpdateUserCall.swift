//
//  UpdateUserCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 30.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class UpdateUserCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init(_ updateDict: [String: Encodable?]) {
        let json = try? JSONSerialization.data(withJSONObject: updateDict, options: .prettyPrinted)
        super.init(httpMethod: .PUT, endpoint: "user", postData: json)
    }
}
