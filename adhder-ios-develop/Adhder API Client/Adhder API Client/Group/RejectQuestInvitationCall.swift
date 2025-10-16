//
//  RejectQuestInvitationCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 03.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RejectQuestInvitationCall: ResponseObjectCall<QuestStateProtocol, APIQuestState> {
    public init(groupID: String) {
        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/quests/reject", postData: nil)
    }
}
