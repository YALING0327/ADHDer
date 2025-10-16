//
//  AdhderNotification.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 23.04.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol NotificationProtocol: BaseModelProtocol {
    
    var id: String { get set }
    var type: AdhderNotificationType { get set }
    var achievementKey: String? { get set }
    var achievementMessage: String? { get set }
    var achievementModalText: String? { get set }
    var seen: Bool { get set }
}

public extension NotificationProtocol {
    var isDismissable: Bool {
        return !id.contains("invite-")
    }
}
