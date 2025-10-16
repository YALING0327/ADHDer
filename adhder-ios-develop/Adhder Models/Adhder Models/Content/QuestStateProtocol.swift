//
//  QuestStateProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 13.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol QuestStateProtocol {
    var active: Bool { get set }
    var key: String? { get set }
    var leaderID: String? { get set }
    var rsvpNeeded: Bool { get set }
    var completed: String? { get set }
    var progress: QuestProgressProtocol? { get set }
    var members: [QuestParticipantProtocol] { get set }
}
