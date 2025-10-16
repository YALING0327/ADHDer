//
//  InviteToQuestCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class InviteToQuestCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(groupID: String, quest: QuestProtocol) {
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/quests/invite/\(quest.key ?? "")", postData: nil)
    }
}
