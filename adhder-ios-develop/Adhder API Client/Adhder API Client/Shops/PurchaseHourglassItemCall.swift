//
//  PurchaseHourglassItemCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class PurchaseHourglassItemCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init(purchaseType: String, key: String) {
        super.init(httpMethod: .POST, endpoint: "user/purchase-hourglass/\(purchaseType)/\(key)", postData: nil)
    }
}
