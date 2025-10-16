//
//  OptOutOfClassCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 27.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class DisableClassesCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init() {
        super.init(httpMethod: .POST, endpoint: "user/disable-classes")
    }
}
