//
//  NotificationQuestInviteProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 02.07.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol NotificationQuestInviteProtocol: NotificationProtocol {
    var questKey: String? { get set }
}
