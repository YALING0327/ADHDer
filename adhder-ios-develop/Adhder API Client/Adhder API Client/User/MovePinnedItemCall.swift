//
//  MovePinnedItemCall.swift
//  Adhder API Client
//
//  Created by Juan on 11/09/21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

public class MovePinnedItemCall: ResponseArrayCall<String, String> {
    public init(item: InAppRewardProtocol, toPosition: Int) {
        super.init(httpMethod: .POST, endpoint: "user/move-pinned-item/\(item.path ?? "")/move/to/\(toPosition)")
    }
}
