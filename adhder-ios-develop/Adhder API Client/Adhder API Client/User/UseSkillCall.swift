//
//  UseSkillCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 28.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class UseSkillCall: ResponseObjectCall<SkillResponseProtocol, APISkillResponse> {
    public init(key: String, target: String? = nil, targetID: String? = nil) {
        var url = "user/class/cast/\(key)"
        if let target = target {
            url += "?targetType=\(target)"
        }
        if let targetId = targetID {
            url += "&targetId=\(targetId)"
        }
        super.init(httpMethod: .POST, endpoint: url)
    }
}
