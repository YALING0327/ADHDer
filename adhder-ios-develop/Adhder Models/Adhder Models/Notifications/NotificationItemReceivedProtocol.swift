//
//  NotificationItemReceivedProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 18.01.23.
//  Copyright © 2023 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol NotificationItemReceivedProtocol: NotificationProtocol {
    var title: String? { get set }
    var message: String? { get set }
    var icon: String? { get set }
    var openDestination: String? { get set }
}
