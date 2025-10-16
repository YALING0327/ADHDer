//
//  OpenMysteryItemCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class OpenMysteryItemCall: ResponseObjectCall<GearProtocol, APIGear> {
    public init() {
        super.init(httpMethod: .POST, endpoint: "user/open-mystery-item", postData: nil)
    }
}
