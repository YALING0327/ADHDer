//
//  SelectClassCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 27.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class SelectClassCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init(class adhderClass: AdhderClass?) {
        var url = "user/change-class"
        if let adhderClass = adhderClass {
            url += "?class=\(adhderClass.rawValue)"
        }
        super.init(httpMethod: .POST, endpoint: url)
    }
}
