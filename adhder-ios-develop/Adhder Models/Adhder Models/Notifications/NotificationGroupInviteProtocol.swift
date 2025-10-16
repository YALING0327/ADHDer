//
//  NotificationGroupInviteProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 02.07.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol NotificationGroupInviteProtocol: NotificationProtocol {
    var groupID: String? { get set }
    var groupName: String? { get set }
    var inviterID: String? { get set }
    var isParty: Bool { get set }
    var isPublicGuild: Bool { get set }
}
