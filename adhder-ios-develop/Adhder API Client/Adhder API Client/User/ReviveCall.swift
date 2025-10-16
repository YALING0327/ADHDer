//
//  ReviveCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class ReviveCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(stubHolder: StubHolderProtocol? = StubHolder(responseCode: 200, stubFileName: "user.json")) {
        super.init(httpMethod: .POST, endpoint: "user/revive", postData: nil, stubHolder: stubHolder)
    }
}
