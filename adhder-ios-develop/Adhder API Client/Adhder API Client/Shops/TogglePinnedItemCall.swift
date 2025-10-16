//
//  TogglePinnedItem.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class TogglePinnedItemCall: ResponseObjectCall<PinResponseProtocol, APIPinResponse> {
    public init(pinType: String, path: String) {
        super.init(httpMethod: .GET, endpoint: "user/toggle-pinned-item/\(pinType)/\(path)", postData: nil)
    }
}
