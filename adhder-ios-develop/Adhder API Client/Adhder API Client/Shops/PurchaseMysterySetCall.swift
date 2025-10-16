//
//  PurchaseMysterySetCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class PurchaseMysterySetCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init(identifier: String) {
        super.init(httpMethod: .POST, endpoint: "user/buy-mystery-set/\(identifier)", postData: nil)
    }
}
