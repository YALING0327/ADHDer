//
//  SellItemCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class SellItemCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init(item: ItemProtocol) {
        super.init(httpMethod: .POST, endpoint: "user/sell/\(item.itemType ?? "")/\(item.key ?? "")", postData: nil)
    }
}
