//
//  RetrieveUser.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 07.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveUserCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init(forceLoading: Bool = false) {
        super.init(httpMethod: .GET, endpoint: "user", ignoreEtag: forceLoading)
    }
}
