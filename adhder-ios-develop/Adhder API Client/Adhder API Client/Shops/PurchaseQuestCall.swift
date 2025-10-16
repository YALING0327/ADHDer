//
//  PurchaseQuestCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class PurchaseQuestCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init(key: String) {
        super.init(httpMethod: .POST, endpoint: "user/buy-quest/\(key)", postData: nil)
    }
}
