//
//  LeaveQuestCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 26.03.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class LeaveQuestCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(groupID: String) {
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/quests/leave", postData: nil)
    }
}
