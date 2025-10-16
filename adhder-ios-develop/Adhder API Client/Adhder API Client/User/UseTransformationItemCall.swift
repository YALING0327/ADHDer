//
//  UseTransformationItemCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 11.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class UseTransformationItemCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(item: SpecialItemProtocol, target: String) {
        let url = "user/class/cast/\(item.key ?? "")?targetType=user&targetId=\(target)"
        super.init(httpMethod: .POST, endpoint: url)
    }
}
